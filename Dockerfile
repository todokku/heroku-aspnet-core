FROM mcr.microsoft.com/dotnet/core/sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln ./aspnetapp/
COPY *.csproj ./aspnetapp/
WORKDIR /app/aspnetapp
RUN dotnet restore
RUN dotnet publish -c Release -o published

FROM mcr.microsoft.com/dotnet/core/aspnet AS runtime
WORKDIR /app
COPY --from=build /app/aspnetapp/published ./
ENTRYPOINT ["dotnet", "heroku-aspnet-core.dll"]