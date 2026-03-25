FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

RUN mkdir -p "/data/packages" \
    mkdir -p "/data/symbols" \
    mkdir -p "/data/db"

ENV Storage__Path "/data"
ENV Search__Type "Database"
ENV Database__Type "Sqlite"
ENV Database__ConnectionString "Data Source=/data/db/bagetter.db"


WORKDIR /app
COPY ./publish /app
EXPOSE 5000
ENTRYPOINT ["dotnet", "BaGetter.dll"]
