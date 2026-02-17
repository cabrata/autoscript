package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"strings"
	"os"
	"time"
)

const (
	BUFLEN       = 4096 * 4
	DEFAULT_HOST = "127.0.0.1:22"
)

// isi password di sini kalau mau pakai X-Pass
const PASS = ""

// HTTP response untuk upgrade / switch protocol
var RESPONSE = []byte("HTTP/1.1 101 Switching Protocols\r\nContent-Length: 104857600000\r\n\r\n")

func main() {
	// flag -b (bind) dan -p (port) mirip parse_args di Python
	bindAddr := flag.String("b", "127.0.0.1", "bind address")
	port := flag.Int("p", 700, "port")
	flag.Parse()

	listenAddr := fmt.Sprintf("%s:%d", *bindAddr, *port)

	ln, err := net.Listen("tcp", listenAddr)
	if err != nil {
		log.Fatalf("Gagal listen di %s: %v", listenAddr, err)
	}
	defer ln.Close()

	log.Println()
	log.Println(":-------GoPythonProxy-------:")
	log.Printf("Listening addr: %s\n", *bindAddr)
	log.Printf("Listening port: %d\n", *port)
	log.Println(":---------------------------:")
	log.Println()

	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Printf("Error accept: %v", err)
			continue
		}
		go handleConnection(conn)
	}
}

func handleConnection(client net.Conn) {
	remoteAddr := client.RemoteAddr().String()
	logPrefix := fmt.Sprintf("Connection: %s", remoteAddr)
	defer func() {
		client.Close()
		log.Printf("%s - closed", logPrefix)
	}()

	// Set read timeout kecil untuk header awal
	_ = client.SetReadDeadline(time.Now().Add(5 * time.Second))

	buf := make([]byte, BUFLEN)
	n, err := client.Read(buf)
	if err != nil {
		log.Printf("%s - error read initial: %v", logPrefix, err)
		return
	}

	// Setelah header dibaca, hilangkan deadline
	_ = client.SetReadDeadline(time.Time{})

	reqStr := string(buf[:n])

	hostPort := findHeader(reqStr, "X-Real-Host")
	if hostPort == "" {
		hostPort = DEFAULT_HOST
	}

	split := findHeader(reqStr, "X-Split")
	if split != "" {
		// Buang data tambahan kalau ada X-Split (mirip Python)
		_, _ = client.Read(buf)
	}

	if hostPort == "" {
		log.Println("- No X-Real-Host!")
		_, _ = client.Write([]byte("HTTP/1.1 400 NoXRealHost!\r\n\r\n"))
		return
	}

	passwd := findHeader(reqStr, "X-Pass")

	// Logic auth & keamanan mirip Python:
	// - Kalau PASS diisi: wajib benar
	// - Kalau PASS kosong: hanya boleh 127.0.0.1 / localhost
	if PASS != "" && passwd != PASS {
		_, _ = client.Write([]byte("HTTP/1.1 400 WrongPass!\r\n\r\n"))
		return
	}
	if PASS == "" && !strings.HasPrefix(hostPort, "127.0.0.1") && !strings.HasPrefix(hostPort, "localhost") {
		_, _ = client.Write([]byte("HTTP/1.1 403 Forbidden!\r\n\r\n"))
		return
	}

	log.Printf("%s - CONNECT %s", logPrefix, hostPort)

	target, err := connectTarget(hostPort)
	if err != nil {
		log.Printf("%s - error connect target: %v", logPrefix, err)
		_, _ = client.Write([]byte("HTTP/1.1 502 Bad Gateway\r\n\r\n"))
		return
	}
	defer target.Close()

	// Kirim response upgrade seperti di Python
	if _, err := client.Write(RESPONSE); err != nil {
		log.Printf("%s - error send RESPONSE: %v", logPrefix, err)
		return
	}

	// Tidak pakai SetDeadline global di sini, biar koneksi bisa hidup lama
	pipe(client, target, logPrefix)
}

func findHeader(data, header string) string {
	// Cari "Header: xxx\r\n"
	search := header + ": "
	idx := strings.Index(data, search)
	if idx == -1 {
		return ""
	}
	start := idx + len(search)
	end := strings.Index(data[start:], "\r\n")
	if end == -1 {
		return ""
	}
	return data[start : start+end]
}

func connectTarget(hostPort string) (net.Conn, error) {
	// kalau tidak ada port, default 443 (mirip method CONNECT Python)
	if !strings.Contains(hostPort, ":") {
		hostPort = hostPort + ":443"
	}
	// bisa pakai DialTimeout supaya tidak ngegantung
	return net.DialTimeout("tcp", hostPort, 10*time.Second)
}

func pipe(a, b net.Conn, logPrefix string) {
	done := make(chan struct{}, 2)

	// a -> b
	go func() {
		_, err := io.Copy(b, a)
		if err != nil && !isTimeout(err) {
			log.Printf("%s - error copy a->b: %v", logPrefix, err)
		}
		done <- struct{}{}
	}()

	// b -> a
	go func() {
		_, err := io.Copy(a, b)
		if err != nil && !isTimeout(err) {
			log.Printf("%s - error copy b->a: %v", logPrefix, err)
		}
		done <- struct{}{}
	}()

	// tunggu salah satu arah selesai, lalu selesai; defer di luar yg nutup koneksi
	<-done
}

func isTimeout(err error) bool {
	if err == nil {
		return false
	}
	nerr, ok := err.(net.Error)
	return ok && nerr.Timeout()
}

// optional: kalau mau print ke file log beda, bisa atur di sini
func init() {
	log.SetOutput(os.Stdout)
	log.SetFlags(log.LstdFlags | log.Lshortfile)
}
