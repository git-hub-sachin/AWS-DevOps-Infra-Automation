FROM hashicorp/terraform:latest
WORKDIR /app
COPY . .
RUN chmod +x run_terraform.sh
ENTRYPOINT ["sh", "/app/run_terraform.sh"]
CMD ["--help"]