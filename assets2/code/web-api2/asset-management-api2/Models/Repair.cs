namespace AssetManagementApi.Models
{
    public class Repair
    {
        public long Id { get; set; }
        public string Status { get; set; }
        public Asset Asset { get; set; }
        public Requester Requester { get; set; }

        public Repair()
        {
            Status = "Created";
        }
    }
}
