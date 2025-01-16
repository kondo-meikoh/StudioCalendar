using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Configuration;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Calendar.v3;
using Google.Apis.Services;
using Newtonsoft.Json.Linq;

namespace StudioCalendar
{
    public partial class index : System.Web.UI.Page
    {
        private static string ApplicationName = "Google Calendar API .NET Quickstart";
        protected int add_week = 0;
        public class calendar
        {
            public DateTime StudioDt;
            public string StudioSummary;
        }

        public class disp
        {
            public DateTime StudioDt;
            public int StudioState; // -1：×、0：-、1：〇
        }

        protected List<disp> sakae_calendar = new List<disp>();
        protected List<disp> aoi_calendar = new List<disp>();

        [Obsolete]
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime start_dt = DateTime.Today;
            if (!string.IsNullOrEmpty(Request.QueryString["aw"]))
            {
                add_week = Convert.ToInt32(Request.QueryString["aw"]);
                start_dt = start_dt.AddDays(7 * add_week);
            }

            var jObject = JObject.Parse(File.ReadAllText(ConfigurationManager.AppSettings["JsonPath"]));
            var serviceAccountEmail = jObject["client_email"].ToString();
            var certificate = jObject["private_key"].ToString();

            var credential = new ServiceAccountCredential(
            new ServiceAccountCredential.Initializer(serviceAccountEmail)
            {
                Scopes = new[] { CalendarService.Scope.Calendar }
            }.FromPrivateKey(certificate));

            // Create Google Calendar API service.
            var service = new CalendarService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = ApplicationName,
            });

            // 栄
            List<calendar> calendar_list_sakae = new List<calendar>();
            string ID_sakae = ConfigurationManager.AppSettings["SakaeID"];
            var request_sakae = new EventsResource.ListRequest(service, ID_sakae);
            request_sakae.TimeMinDateTimeOffset = start_dt;
            request_sakae.TimeMaxDateTimeOffset = start_dt.AddDays(7);
            request_sakae.SingleEvents = true;
            request_sakae.OrderBy = EventsResource.ListRequest.OrderByEnum.StartTime;

            var events_sakae = request_sakae.Execute();
            if (events_sakae.Items != null && events_sakae.Items.Count > 0)
            {
                foreach (var eventItem in events_sakae.Items)
                {
                    string when = eventItem.Start.DateTime.ToString();
                    if (String.IsNullOrEmpty(when))
                    {
                        when = eventItem.Start.Date;
                    }
                    calendar cal = new calendar();
                    cal.StudioSummary = eventItem.Summary;
                    cal.StudioDt = Convert.ToDateTime(when);
                    calendar_list_sakae.Add(cal);
                }
            }

            // 葵
            List<calendar> calendar_list_aoi = new List<calendar>();
            string ID_aoi = ConfigurationManager.AppSettings["AoiID"];
            var request_aoi = new EventsResource.ListRequest(service, ID_aoi);
            request_aoi.TimeMinDateTimeOffset = start_dt;
            request_aoi.TimeMaxDateTimeOffset = start_dt.AddDays(7);
            request_aoi.SingleEvents = true;
            request_aoi.OrderBy = EventsResource.ListRequest.OrderByEnum.StartTime;

            var events_aoi = request_aoi.Execute();
            if (events_aoi.Items != null && events_aoi.Items.Count > 0)
            {
                foreach (var eventItem in events_aoi.Items)
                {
                    string when = eventItem.Start.DateTime.ToString();
                    if (String.IsNullOrEmpty(when))
                    {
                        when = eventItem.Start.Date;
                    }
                    calendar cal = new calendar();
                    cal.StudioSummary = eventItem.Summary;
                    cal.StudioDt = Convert.ToDateTime(when);
                    calendar_list_aoi.Add(cal);
                }
            }

            for(int i = 0; i < 7; i++)
            {
                DateTime date = start_dt.AddDays(i);
                for(int j = 1; j <= 4; j++)
                {
                    string[] sakae_time_ary = ConfigurationManager.AppSettings["SakaeDt" + j].Split(':');
                    DateTime sakae_dt = date.AddHours(Convert.ToInt32(sakae_time_ary[0])).AddMinutes(Convert.ToInt32(sakae_time_ary[1]));
                    int sakae_state = 0;
                    disp sakae_cal = new disp();
                    sakae_cal.StudioDt = sakae_dt;
                    if(sakae_dt > DateTime.Now)
                    {
                        calendar cal_find = calendar_list_sakae.Find(x => x.StudioDt == sakae_dt);
                        if(cal_find != null)
                        {
                            if(cal_find.StudioSummary == ConfigurationManager.AppSettings["SakaeOk"])
                            {
                                sakae_state = 1;
                            }
                            else
                            {
                                sakae_state = -1;
                            }
                        }
                    }
                    sakae_cal.StudioState = sakae_state;
                    sakae_calendar.Add(sakae_cal);

                    string[] aoi_time_ary = ConfigurationManager.AppSettings["AoiDt" + j].Split(':');
                    DateTime aoi_dt = date.AddHours(Convert.ToInt32(aoi_time_ary[0])).AddMinutes(Convert.ToInt32(aoi_time_ary[1]));
                    int aoi_state = 0;
                    disp aoi_cal = new disp();
                    aoi_cal.StudioDt = aoi_dt;
                    if (aoi_dt > DateTime.Now)
                    {
                        calendar cal_find = calendar_list_aoi.Find(x => x.StudioDt == aoi_dt);
                        if (cal_find != null)
                        {
                            if (cal_find.StudioSummary == ConfigurationManager.AppSettings["AoiOk"])
                            {
                                aoi_state = 1;
                            }
                            else
                            {
                                aoi_state = -1;
                            }
                        }
                    }
                    aoi_cal.StudioState = aoi_state;
                    aoi_calendar.Add(aoi_cal);
                }
            }
        }
    }
}