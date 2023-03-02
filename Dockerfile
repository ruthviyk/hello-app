# Use Microsoft's official build .NET image.
# https://hub.docker.com/_/microsoft-dotnet-core-sdk/
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /app

# Install production dependencies.
# Copy csproj and restore as distinct layers.
COPY *.csproj ./
RUN dotnet restore

# Copy local code to the container image.
COPY . .


# Build a release artifact.
RUN dotnet publish -c Release -o /publish

# Use Microsoft's official runtime .NET image.
# https://hub.docker.com/_/microsoft-dotnet-core-aspnet/
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS runtime
WORKDIR /publish
COPY --from=build-env /publish .
EXPOSE 80

# Make sure the app binds to port 8081
ENV ASPNETCORE_URLS http://*:8080
ENV ASPNETCORE_ENVIRONMENT Development

# Run the web service on container startup.
ENTRYPOINT ["dotnet", "hello-app.dll"]
