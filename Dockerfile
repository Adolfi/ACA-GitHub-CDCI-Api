#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["ACA-GitHub-CDCI-Api.csproj", "."]
RUN dotnet restore "./ACA-GitHub-CDCI-Api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ACA-GitHub-CDCI-Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ACA-GitHub-CDCI-Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ACA-GitHub-CDCI-Api.dll"]