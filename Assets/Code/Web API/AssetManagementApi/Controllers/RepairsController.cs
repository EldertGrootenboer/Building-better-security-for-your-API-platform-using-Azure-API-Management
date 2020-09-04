using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AssetManagementApi.Models;

namespace OrderSystemApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RepairsController : ControllerBase
    {
        private readonly RepairContext _context;

        public RepairsController(RepairContext context)
        {
            _context = context;

            if (!context.Repairs.Any())
            {
                _context.AddRange(new List<Repair>
                {
                    new Repair
                    {
                        Requester = new Requester { Name = "John Smith", PhoneNumber = "0675214572", Email = "john.smith@microsoft.com" },
                        Asset = new Asset { Location = "West corner of Microsoft Way, Redmond", AssetType = "Street Light" }
                    },
                    new Repair
                    {
                        Requester = new Requester { Name = "Claire Smith", PhoneNumber = "0622486247", Email = "claire1@outlook.com" },
                        Asset = new Asset { Location = "Intersection of Four Lanes & Cycle Track, Berlin", AssetType = "Generator" }
                    },
                    new Repair
                    {
                        Requester = new Requester { Name = "Luis Vasque", PhoneNumber = "0614756328", Email = "luisvasque@tbb.nl" },
                        Asset = new Asset { Location = "Out front of central station, The Hague", AssetType = "Switch Box" }
                    }
                });

                _context.SaveChanges();
            }
        }

        // GET: api/Repairs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Repair>>> GetRepairs()
        {
            return await _context.Repairs
                .Include(repair => repair.Requester)
                .Include(repair => repair.Asset)
                .ToListAsync();
        }

        // GET: api/Repairs/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Repair>> GetRepair(long id)
        {
            var repair = await _context.Repairs
                .Include(repair => repair.Requester)
                .Include(repair => repair.Asset)
                .FirstOrDefaultAsync(repair => repair.Id == id);

            if (repair == null)
            {
                return NotFound();
            }

            return repair;
        }

        // PUT: api/Repairs/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRepair(long id, Repair repair)
        {
            if (id != repair.Id)
            {
                return BadRequest();
            }

            _context.Entry(repair).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RepairExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Repairs
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Repair>> PostRepair(Repair repair)
        {
            _context.Repairs.Add(repair);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetRepair", new { id = repair.Id }, repair);
        }

        // DELETE: api/Repairs/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Repair>> DeleteRepair(long id)
        {
            var repair = await _context.Repairs.FindAsync(id);
            if (repair == null)
            {
                return NotFound();
            }

            _context.Repairs.Remove(repair);
            await _context.SaveChangesAsync();

            return repair;
        }

        private bool RepairExists(long id)
        {
            return _context.Repairs.Any(e => e.Id == id);
        }
    }
}
