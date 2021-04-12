using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace URLShortener.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ShortenerController : ControllerBase
    {
        private readonly ILogger<ShortenerController> _logger;

        public ShortenerController(ILogger<ShortenerController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public string Get()
        {
            // Generate a random short code
            var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var random = new Random();
            var shortCode = new string(Enumerable.Repeat(chars, 6)
              .Select(s => s[random.Next(s.Length)]).ToArray());

            // Return the short URL
            return "https://example.com/" + shortCode;
        }
    }
}
