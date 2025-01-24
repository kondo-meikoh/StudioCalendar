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

        <p class="disc">ご予約、お問い合わせは担当営業までご連絡ください。</p>

        <section id="sakae">
            <div class="head">
                <div class="name">
                    <h1>栄スタジオ</h1>
                    <p class="disc">名古屋市中区栄3-20-9 佳陽ビル 4F</p>
                </div>
                <a href="https://x.gd/TOiC1">
                    <svg class="icon_map" viewBox="0 0 64 64">
                        <title>GooglaMapを開く</title>
                        <path style="fill:#fff;" d="M24.67 44.83 39.84 60h11.08L30.23 39.3l-5.56 5.53z"/>
                        <path d="M9.82 59.69c.7.2 1.43.31 2.18.31h27.84L24.67 44.83 9.81 59.69Z" style="fill:#4a9bf6;"/>
                        <path d="M54.13 4.3C53.45 4.11 52.74 4 52 4H12c-4.42 0-8 3.58-8 8v40c0 .74.11 1.45.3 2.13L54.13 4.3Z" style="fill:#28be77;"/>
                        <path d="M30.23 39.3 50.93 60h1.08c4.42 0 8-3.58 8-8V12c0-.76-.11-1.49-.31-2.18L30.24 39.31Z" style="fill:#d3d9f2;"/>
                        <path d="M59.69 9.82a8.008 8.008 0 0 0-5.56-5.52L4.3 54.13a7.99 7.99 0 0 0 5.52 5.56L59.69 9.82Z" style="fill:#ffdf64;"/>
                        <path d="M24.67 44.83 39.84 60h11.08l-20.7-20.7-5.55 5.53Z" style="fill:#fff;"/>
                        <path d="M54.49 20.92c0 7.54-7.7 15.31-12.9 20.51-5.2-5.16-12.9-12.79-12.9-20.51 0-7.12 5.79-12.65 12.9-12.65s12.9 5.53 12.9 12.65Z" style="fill:#d73d3f;"/>
                        <path d="M41.59 26.77c3.09 0 5.6-2.51 5.6-5.6s-2.51-5.6-5.6-5.6-5.6 2.51-5.6 5.6 2.51 5.6 5.6 5.6Z" style="fill:#a83229;"/>
                    </svg>
                </a>
            </div><%--head--%>

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
            <div class="head">
                <div class="name">
                    <h1>葵スタジオ</h1>
                    <p class="disc">名古屋市東区葵1-19-4 サッサウエスタンビル 4F</p>
                </div>
                <a href="https://goo.gl/maps/Yo1qjGr1JCF2">
                    <svg class="icon_map" viewBox="0 0 64 64">
                        <title>GooglaMapを開く</title>
                        <path style="fill:#fff;" d="M24.67 44.83 39.84 60h11.08L30.23 39.3l-5.56 5.53z"/>
                        <path d="M9.82 59.69c.7.2 1.43.31 2.18.31h27.84L24.67 44.83 9.81 59.69Z" style="fill:#4a9bf6;"/>
                        <path d="M54.13 4.3C53.45 4.11 52.74 4 52 4H12c-4.42 0-8 3.58-8 8v40c0 .74.11 1.45.3 2.13L54.13 4.3Z" style="fill:#28be77;"/>
                        <path d="M30.23 39.3 50.93 60h1.08c4.42 0 8-3.58 8-8V12c0-.76-.11-1.49-.31-2.18L30.24 39.31Z" style="fill:#d3d9f2;"/>
                        <path d="M59.69 9.82a8.008 8.008 0 0 0-5.56-5.52L4.3 54.13a7.99 7.99 0 0 0 5.52 5.56L59.69 9.82Z" style="fill:#ffdf64;"/>
                        <path d="M24.67 44.83 39.84 60h11.08l-20.7-20.7-5.55 5.53Z" style="fill:#fff;"/>
                        <path d="M54.49 20.92c0 7.54-7.7 15.31-12.9 20.51-5.2-5.16-12.9-12.79-12.9-20.51 0-7.12 5.79-12.65 12.9-12.65s12.9 5.53 12.9 12.65Z" style="fill:#d73d3f;"/>
                        <path d="M41.59 26.77c3.09 0 5.6-2.51 5.6-5.6s-2.51-5.6-5.6-5.6-5.6 2.51-5.6 5.6 2.51 5.6 5.6 5.6Z" style="fill:#a83229;"/>
                    </svg>
                </a>
            </div><%--head--%>

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