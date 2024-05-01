# Собираем из базового образа
FROM golang:1.22 as builder

# Указываем, в какой директории работаем
WORKDIR /app

# Копируем файлы модуля
COPY go.mod go.sum ./

# Скачиваем нужные зависимости
RUN go mod download

# Копируем остальные файлы проекта
COPY . .

# Сборка приложения
RUN CGO_ENABLED=0 GOOS=linux go build -o myapp .

# scratch (пустой образ) для минимизации размера конечного образа
FROM scratch

# Копируем исполняемый файл в пустой образ
COPY --from=builder /app/myapp /myapp

# Указываем, какой порт будет доступен
# Порт не публикуется, это больше для документации
EXPOSE 8080

# Запуск приложения
CMD ["/myapp"]
