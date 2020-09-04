using System;

namespace AssetManagementApi.Models
{
    public class Asset
    {
        public long Id { get; set; }
        public string AssetType { get; set; }
        public string Location { get; set; }
    }
}
