:: compile ExposePlayerIOClient
ildasm /out=PIO.il ..\DotNetCore\PlayerIOClient.dll

dotnet build ExposePlayerIOClient\ExposePlayerIOClient.csproj
dotnet ExposePlayerIOClient\bin\Debug\netcoreapp2.1\ExposePlayerIOClient.dll PIO.il PIOOut.il

ilasm /dll PIOOut.il /resource=PIO.res /out=ExposePlayerIOClient.dll