FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 58766
EXPOSE 44377

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["Docker.webapi/Docker.webapi.csproj", "Docker.webapi/"]
RUN dotnet restore "Docker.webapi/Docker.webapi.csproj"
COPY . .
WORKDIR "/src/Docker.webapi"
RUN dotnet build "Docker.webapi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Docker.webapi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Docker.webapi.dll"]