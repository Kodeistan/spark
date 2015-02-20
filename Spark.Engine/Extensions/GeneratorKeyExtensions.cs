﻿using Hl7.Fhir.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Spark.Core
{
    public static class GeneratorKeyExtensions
    {
        public static Key NextHistoryKey(this IGenerator generator, Key key)
        {
            Key historykey = key;
            historykey.VersionId = generator.NextVersionId(key.TypeName);
            return historykey;
        }

        public static Key NextKey(this IGenerator generator, string type)
        {
            string id = generator.NextResourceId(type);
            string versionid = generator.NextVersionId(type);
            return Key.CreateLocal(type, id);
        }

        public static Key NextKey(this IGenerator generator, Key key)
        {
            string resourceid = generator.NextResourceId(key.TypeName);
            string versionid = generator.NextVersionId(key.TypeName);
            return Key.CreateLocal(key.TypeName, resourceid, versionid);
        }

        public static Key NextKey(this IGenerator generator, Resource resource)
        {
            Key key = resource.ExtractKey();
            return generator.NextKey(key);
        }
    }
}
