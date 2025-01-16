<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="StudioCalendar.index" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>スタジオ空き状況</title>
    <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="js/index.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input type="hidden" id="hdn_week" value="<%= add_week %>" />
            <input type="button" id="reload" value="最新表示" />
            <% if (add_week != 0) {%>
            <input type="button" id="this_week" value="今週" />
            <input type="button" id="prev_week" value="前の週" />
            <%} else {%>
            <span class="disabled">今週</span>
            <span class="disabled">前の週</span>
            <% } %>
            <% if (add_week >= 5)
                {%>
            <span class="disabled">次の週</span>
            <% } else {%>
            <input type="button" id="next_week" value="次の週" />
            <% } %>

            <table>
                <thead>
                    <tr>
                        <th>栄</th>
                        <% DateTime date = DateTime.Today.AddDays(add_week * 7);
                            for(int i = 0; i < 7; i++) {%>
                        <th><%= date.AddDays(i).Day %><br /><%= date.AddDays(i).ToString("(ddd)") %></th>
                        <% }%>
                    </tr>
                </thead>
                <tbody>
                    <% for (int i = 1; i <= 4; i++) 
                        {
                            string time_str = ConfigurationManager.AppSettings["SakaeDt" + i];
                            string[] time_ary = time_str.Split(':');%>
                    <tr>
                        <td><%= time_str %></td>
                        <% for (int j = 0; j < 7; j++)
                            {
                                DateTime dtime = date.AddDays(j).AddHours(Convert.ToInt32(time_ary[0])).AddMinutes(Convert.ToInt32(time_ary[1]));
                                disp sakae = sakae_calendar.Find(x => x.StudioDt == dtime);
                                string class_str = "state";
                                string disp_str = string.Empty;
                                switch (sakae.StudioState)
                                {
                                    case -1:
                                        class_str += " nan";
                                        disp_str = "×";
                                        break;
                                    case 0:
                                        class_str += " nan";
                                        disp_str = "-";
                                        break;
                                    case 1:
                                        class_str += " ok";
                                        disp_str = "〇";
                                        break;
                                }%>
                        <td class="<%= class_str %>"><%= disp_str %></td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <table>
                <thead>
                    <tr>
                        <th>葵</th>
                        <% for(int i = 0; i < 7; i++) {%>
                        <th><%= date.AddDays(i).Day %><br /><%= date.AddDays(i).ToString("(ddd)") %></th>
                        <% }%>
                    </tr>
                </thead>
                <tbody>
                    <% for (int i = 1; i <= 4; i++) 
                        {
                            string time_str = ConfigurationManager.AppSettings["AoiDt" + i];
                            string[] time_ary = time_str.Split(':');%>
                    <tr>
                        <td><%= time_str %></td>
                        <% for (int j = 0; j < 7; j++)
                            {
                                DateTime dtime = date.AddDays(j).AddHours(Convert.ToInt32(time_ary[0])).AddMinutes(Convert.ToInt32(time_ary[1]));
                                disp aoi = aoi_calendar.Find(x => x.StudioDt == dtime);
                                string class_str = "state";
                                string disp_str = string.Empty;
                                switch (aoi.StudioState)
                                {
                                    case -1:
                                        class_str += " nan";
                                        disp_str = "×";
                                        break;
                                    case 0:
                                        class_str += " nan";
                                        disp_str = "-";
                                        break;
                                    case 1:
                                        class_str += " ok";
                                        disp_str = "〇";
                                        break;
                                }%>
                        <td class="<%= class_str %>"><%= disp_str %></td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
