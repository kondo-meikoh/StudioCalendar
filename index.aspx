<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="StudioCalendar.index" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html lang="ja">

<head runat="server">
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>スタジオ空き状況</title>

    <%-- webクリップアイコン --%>
	<link rel="icon" href="image/favicon.ico"　sizes="32x32" type="image/vnd.microsoft.icon">
    <link rel="icon" href="image/favicon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="image/apple-touch-icon.png">
    <link rel="manifest" href="/manifest.webmanifest" crossorigin="use-credentials">


	<%-- GoogleFonts --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

    <%-- css --%>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/destyle.css@4.0.0/destyle.min.css">
    <link rel="stylesheet" href="css/index.css">

    <%-- js --%>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="js/index.js" defer></script>
</head>

<body><form id="form1" runat="server">

    <main>
        <div id="bt">
            <input type="hidden" id="hdn_week" value="<%= add_week %>" />
            <input type="button" id="reload" value="更新" />
            <% if (add_week != 0) {%>
            <input type="button" id="this_week" value="今週" />
            <input type="button" id="prev_week" value="前の週" />
            <%} else {%>
            <span class="disabled">今週</span>
            <span class="disabled">前の週</span>
            <% } %>
            <% if (add_week >= 4) { %>
            <span class="disabled">次の週</span>
            <% } else {%>
            <input type="button" id="next_week" value="次の週" />
            <% } %>
        </div><%--bt--%>

        <section id="sakae">
            <h1>栄スタジオ</h1>
            <ul class="cal">
                <% DateTime date = DateTime.Today.AddDays(add_week * 7);%>
                <li class="weekday"><span><%= date.Month %><i class="month">月</i></span></li>
                <%
                    for(int i = 0; i < 7; i++) {
                %>
                <li class="weekday"><i class="text"><%= date.AddDays(i).ToString("ddd") %></i><%= date.AddDays(i).Day %></li>
                <% } %>

                <%
                    for (int i = 1; i <= 4; i++) {
                    string time_str = ConfigurationManager.AppSettings["SakaeDt" + i];
                    string[] time_ary = time_str.Split(':');
                %>
                <li class="time"><%= time_str %></li>

                <% for (int j = 0; j < 7; j++)
                    {
                    DateTime dtime = date.AddDays(j).AddHours(Convert.ToInt32(time_ary[0])).AddMinutes(Convert.ToInt32(time_ary[1]));
                    disp sakae = sakae_calendar.Find(x => x.StudioDt == dtime);
                    string class_str = "state";
                    string disp_str = string.Empty;
                    switch (sakae.StudioState)
                    {
                        case -1:
                            class_str += "nan";
                            disp_str = "×";
                            break;
                        case 0:
                            class_str += "nan";
                            disp_str = "-";
                            break;
                        case 1:
                            class_str += "ok";
                            disp_str = "〇";
                            break;
                    } %>
                <li class="<%= class_str %>"><%= disp_str %></li>
                <% } %>
                <% } %>
            </ul>
        </section><%--sakae--%>

        <section id="aoi">
            <h1>葵スタジオ</h1>
            <ul class="cal">
                <li class="weekday"><span><%= date.Month %><i class="month">月</i></span></li>
                <%
                    for(int i = 0; i < 7; i++) {
                %>
                <li class="weekday"><i class="text"><%= date.AddDays(i).ToString("ddd") %></i><%= date.AddDays(i).Day %></li>
                <% } %>

                <%
                    for (int i = 1; i <= 4; i++) {
                    string time_str = ConfigurationManager.AppSettings["AoiDt" + i];
                    string[] time_ary = time_str.Split(':');
                %>
                <li class="time"><%= time_str %></li>

                <% for (int j = 0; j < 7; j++)
                    {
                    DateTime dtime = date.AddDays(j).AddHours(Convert.ToInt32(time_ary[0])).AddMinutes(Convert.ToInt32(time_ary[1]));
                    disp aoi = aoi_calendar.Find(x => x.StudioDt == dtime);
                    string class_str = "state";
                    string disp_str = string.Empty;
                    switch (aoi.StudioState)
                    {
                        case -1:
                            class_str += "nan";
                            disp_str = "×";
                            break;
                        case 0:
                            class_str += "nan";
                            disp_str = "-";
                            break;
                        case 1:
                            class_str += "ok";
                            disp_str = "〇";
                            break;
                    } %>
                <li class="<%= class_str %>"><%= disp_str %></li>
                <% } %>
                <% } %>
            </ul>
        </section><%--aoi--%>
    </main>
</form></body>
</html>