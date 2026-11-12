FROM node:24-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG API_URL=http://localhost:1337
RUN sed -i "s|http://localhost:1337|${API_URL}|" src/environments/environment.prod.ts \
 && npx ng build --configuration production

FROM nginx:1.29-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/backoffice/browser /usr/share/nginx/html
EXPOSE 80
