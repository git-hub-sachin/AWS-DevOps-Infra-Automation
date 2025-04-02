FROM hashicorp/terraform:latest
WORKDIR /app
COPY . .
RUN chmod +x run_terraform.sh
ENTRYPOINT ["/app/run_terraform.sh"]
CMD ["--help"]