FROM 192.168.56.12/k8s-ops/nginx:1.16.1-alpine
ADD index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
