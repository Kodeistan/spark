﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using System.Threading;
using Tasks = System.Threading.Tasks;
using System.Web;
using System.Xml;
using Hl7.Fhir.Model;
using Spark.Engine.Core;

namespace Spark.Formatters
{
    public class XmlBundleFormatter :  MediaTypeFormatter
    {
        public XmlBundleFormatter()
        {
            SupportedMediaTypes.Add(new MediaTypeHeaderValue(FhirMediaType.XmlResource));
        }
        public override bool CanReadType(Type type)
        {
            return (type == typeof(Bundle)) || (type == typeof(Resource));
        }
        public override bool CanWriteType(Type type)
        {
            return type == typeof(Bundle);
        }
        public override Tasks.Task<object> ReadFromStreamAsync(Type type, Stream readStream, HttpContent content, IFormatterLogger formatterLogger)
        {
            return Tasks.Task.FromResult<object>(null);
        }
    }
}
