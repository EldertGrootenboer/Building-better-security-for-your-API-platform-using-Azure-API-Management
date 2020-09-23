# Asset Management API

This API exposes an asset management system using an in-memory database.

## Creating the API

The steps for creating the API can be found on [https://docs.microsoft.com/en-us/aspnet/core/tutorials/first-web-api?view=aspnetcore-3.1&tabs=visual-studio-code].
We did run into the below issue while scaffolding the controller.

> Scaffolding failed. Failed to get Project Context <project_path>.

This was solved by installing version 3.1.3 of the codegenerator tool instead.

``` powershell
dotnet tool install --global dotnet-aspnet-codegenerator --version 3.1.3
```

## Scaffolding

When making changes to the model, we can re-scaffold our controller using the following command.

``` powershell
dotnet aspnet-codegenerator controller -name RepairsController -async -api -m Repair -dc RepairContext -outDir Controllers -f
```

After scaffolding we need to update the GET operations to include the repair details. Replace the corresponding lines with the following code.

``` csharp
// GET: api/Repairs
[HttpGet]
public async Task<ActionResult<IEnumerable<Repair>>> GetRepairs()
{
    return await _context.Repairs.Include(repair => repair.Requester).Include(repair => repair.Asset).ToListAsync();
}

// GET: api/Repairs/5
[HttpGet("{id}")]
public async Task<ActionResult<Repair>> GetRepair(long id)
{
    var repair = await _context.Repairs.Include(repair => repair.Requester).Include(repair => repair.Asset).FirstOrDefaultAsync(repair => repair.Id == id);

    if (repair == null)
    {
        return NotFound();
    }

    return repair;
}
```

### Publishing

Once the app is complete, we need to publish it to Azure. First create a release package using the following command.

``` powershell
dotnet publish -c Release -o ./publish
```

Then right click the publish folder and select _Deploy to Web App..._, and follow the steps to publish the API. This does require the Azure App Service extension to be installed in Visual Studio Code.
