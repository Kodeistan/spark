﻿namespace Spark.Store.Sql.Model
{
    public class BundleSnapshotResource
    {
        public int Id { get; set; }
        public string ResourceKey { get; set; }
       // public virtual Resource Resource { get; set; }
        public int BundleSnapshotId { get; set; }
        public virtual BundleSnapshot BundleSnapshot { get; set; }
    }
}