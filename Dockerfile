FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY heroku-aspnet-core/*.sln .
COPY heroku-aspnet-core/*.csproj ./heroku-aspnet-core/
RUN dotnet restore

# copy everything else and build app
COPY heroku-aspnet-core/. ./heroku-aspnet-core/
WORKDIR /app/heroku-aspnet-core
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
WORKDIR /app
COPY --from=build /app/heroku-aspnet-core/out ./
ENTRYPOINT ["dotnet", "heroku-aspnet-core.dll"]