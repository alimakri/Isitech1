using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClrSQL
{
    public static class CryptoSimple
    {
        public static string Crypt(int key, string message)
        {
            int align = 0;
            string buffer = "";
            
            foreach (char c in message)
            {
                align = c - key;
                
                if (align < 'A') {
                    align += 26;
                }
                resultat += align;
            }
            
            return (buffer);
        }
        
        public static string Decrypt(int key, string message)
        {
            int align = 0;
            char hidder = 'Z';
            string buffer = "";
            
            foreach (char c in message)
            {
                align = c + key;
                if (align > hidder) {
                    align -= hidder;
                }
                resultat += align;
            }
            
            return (buffer);
        }
    }
}
