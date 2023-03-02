using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClrSQL
{
	public static class DateConvertion
	{
		public static string DateConvert(string date, string format)
		{
			try
			{
				CultureInfo provider = new CultureInfo("en-US");

				string[] inputFormats = {
				"MM/dd/yyyy", "M/d/yyyy", "M/dd/yyyy","dd/MM/yyyy",
				"MM/d/yyyy", "M/d/yyyy h:mm:ss tt", "MM/d/yyyy h:mm:ss tt",
				"M/d/yyyy h:mm tt", "MM/dd/yyyy hh:mm:ss", "M/d/yyyy h:mm:ss",
				"M/d/yyyy hh:mm tt", "M/d/yyyy hh tt", "M/d/yyyy h:mm", "M/d/yyyy h:mm",
				"MM/dd/yyyy hh:mm", "M/dd/yyyy hh:mm",
				"MM-dd-yyyy", "M-d-yyyy", "M-dd-yyyy","dd-MM-yyyy",
				"MM-d-yyyy", "M-d-yyyy h:mm:ss tt", "MM-d-yyyy h:mm:ss tt",
				"M-d-yyyy h:mm tt", "MM-dd-yyyy hh:mm:ss", "M-d-yyyy h:mm:ss",
				"M-d-yyyy hh:mm tt", "M-d-yyyy hh tt", "M-d-yyyy h:mm", "M-d-yyyy h:mm",
				"MM-dd-yyyy hh:mm", "M-dd-yyyy hh:mm"};

				DateTime dt = DateTime.ParseExact(date, inputFormats, provider, DateTimeStyles.None);

				return dt.ToString(format);
			}
			catch
			{
				return string.Empty;
			}
		}
	}
}
