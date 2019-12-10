FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app

# Allow build arguments that target environment variables so we can change certain runtime
# properties without having to change the source code or app settings Json
ARG SPARK_PORT=8080
ARG SPARK_MONGO_CONNECTION_STRING
ARG SPARK_MONGO_USE_SSL=true

ENV SPARK_PORT ${SPARK_PORT}
ENV SPARK_MONGO_CONNECTION_STRING ${OBJECT_MONGO_CONNECTION_STRING}
ENV SPARK_MONGO_USE_SSL ${OBJECT_MONGO_USE_SSL}

# Running on port 80 results in an error when not running the container as root in 
# OpenShift (RedHat's flavor of Kubernetes), which can be problematic when 
# security-hardening the container. The following lines allow us to change the port
# without having to modify a Dockerfile to do so.
EXPOSE ${SPARK_PORT}/tcp
ENV ASPNETCORE_URLS=http://*:${SPARK_PORT}

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["./src/Spark/", "Spark/"]
COPY ["./src/Spark.Web/", "Spark.Web/"]
COPY ["./src/Spark.Engine/", "Spark.Engine/"]
COPY ["./src/Spark.Mongo/", "Spark.Mongo/"]
RUN dotnet restore "/src/Spark.Web/Spark.Web.csproj"
COPY . .
RUN dotnet build "/src/Spark.Web/Spark.Web.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "/src/Spark.Web/Spark.Web.csproj" -c Release -o /app

RUN rm -rf /src/Spark/

FROM base AS final

WORKDIR /app
COPY --from=publish /app .
# COPY --from=build /src/Spark.Web/example_data/fhir_examples ./fhir_examples

# Don't run as root user for security purposes. These lines are also required if
# the container is running in OpenShift on the most restrictive settings.
RUN chown 1001:0 /app/Spark.Web.dll
RUN chmod g+rwx /app/Spark.Web.dll
USER 1001

ENTRYPOINT ["dotnet", "Spark.Web.dll"]