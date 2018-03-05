package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"

	_ "github.com/prometheus/prom2json" // dummy (don't remove)
)

func main() {
	cert := flag.String("cert", "", "certificate file")
	key := flag.String("key", "", "key file")
	skipServerCertCheck := flag.Bool("accept-invalid-cert", false, "Accept any certificate during TLS handshake. Insecure, use only for testing.")
	port := flag.Int("port", 80, "port number to expose")
	path := flag.String("path", "/", "path to expose")
	prom2json := flag.String("prom2jsoncmd", "", "[MANDATORY] executable prom2json command")
	flag.Parse()

	if len(flag.Args()) != 1 {
		log.Fatalf("Usage: %s METRICS_URL", os.Args[0])
	}
	if (*cert != "" && *key == "") || (*cert == "" && *key != "") {
		log.Fatalf("Usage: %s METRICS_URL\n with TLS client authentication: %s -cert=/path/to/certificate -key=/path/to/key METRICS_URL", os.Args[0], os.Args[0])
	}
	if *prom2json == "" {
		log.Fatalf("--prom2jsoncmd is a mandatory parameter: please specify the path to the command")
	}

	metricsURL := flag.Args()[0]

	args := []string{
		"--cert",
		*cert,
		"--key",
		*key,
	}
	if *skipServerCertCheck {
		args = append(args, "--accept-invalid-cert")
	}
	args = append(args, metricsURL)

	http.HandleFunc(*path, func(w http.ResponseWriter, req *http.Request) {
		out, err := exec.Command(*prom2json, args...).Output()
		if err != nil {
			log.Println("[ERROR] failed to retrieve metrics:", err)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Content-Length", fmt.Sprintf("%d", len(out)))
		w.Write(out)
	})
	log.Printf("listening... [path=%s, port=%d]", *path, *port)
	err := http.ListenAndServe(fmt.Sprintf(":%d", *port), nil)
	log.Fatal(err)
}
