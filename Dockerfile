# 建置階段
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 複製專案檔並還原
COPY AspNetCoreApi.csproj .
RUN dotnet restore

# 複製其餘原始碼並建置
COPY . .
RUN dotnet publish -c Release -o /app/publish --no-restore

# 執行階段
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# 從建置階段複製發佈結果
COPY --from=build /app/publish .

# 暴露 API 埠（可依 launchSettings 調整）
EXPOSE 8080
EXPOSE 8081

# 設定 Kestrel 監聽埠（容器常用 8080）
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "AspNetCoreApi.dll"]
