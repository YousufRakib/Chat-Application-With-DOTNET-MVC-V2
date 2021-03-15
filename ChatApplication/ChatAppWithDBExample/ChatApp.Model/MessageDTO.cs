﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ChatAppWithDBExample.ChatApp.Model
{
    public class MessageDTO
    {
        public int ID { get; set; }
        public string Message { get; set; }

        public int? FromUser { get; set; }

        public int? ToUser { get; set; }
        public string Class { get; set; }
    }
}