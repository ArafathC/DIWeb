<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="scripts/jquery-ui.min.js"></script>
<script type="text/javascript" src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization','version':'1','packages':['corechart']}]}"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>
<script src="scripts/premiumAPI.js" type="text/javascript"></script>
<link rel="stylesheet" href="css/jquery-ui.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>City Data</title>
</head>
<body>
<table>
<tr><td style="width:700 px; vertical-align:top">
<div id="leftHalf" style="vertical-align:top;"></div>
<div id="container" style="width: 700px; height: 270px; margin: 0 auto"></div>
<div style="height:400px;overflow:auto" id="rightHalf"></div>
</td>
<td style="width:400px;vertical-align:top">
<div id='chart_div'></div>
<div id='chart_pop_div'></div>
<div id='chart_employment_div'></div>
</td></tr>
</table>
<form action ="CityServlet">
</form>
</body>
<script type="text/javascript">
String.prototype.count=function(s1) { 
    return (this.length - this.replace(new RegExp(s1,"g"), '').length) / s1.length;
}
function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
$(document).ready(function () {
	var latitude = getParameterByName('Latitude');
	var longitude = getParameterByName('Longitude');
	$.ajax({
		url:"/DIWeb/SelectData",
		type:"get",
		data:{action: 'CITY Info',latitude:latitude, longitude:longitude},
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error Occured");
		},
		success:function(data){
			var obj = jQuery.parseJSON(data);
			parseOutput(obj);
		}
	});
	$.ajax({
		url:"/DIWeb/SelectData",
		type:"get",
		data:{action: 'GDP Data', latitude:latitude, longitude:longitude},
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error Occured");
		},
		success:function(data){
			var obj = jQuery.parseJSON(data);
			bindAutoComplete(obj);
		}
	});
	$.ajax({
		url:"/DIWeb/SelectData",
		type:"get",
		data:{action: 'POP Data', latitude:latitude, longitude:longitude},
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error Occured");
		},
		success:function(data){
			var obj = jQuery.parseJSON(data);
			bindPOPAutoComplete(obj);
		}
	});
	$.ajax({
		url:"/DIWeb/SelectData",
		type:"get",
		data:{action: 'Employment', latitude:latitude, longitude:longitude},
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error Occured");
		},
		success:function(data){
			var obj = jQuery.parseJSON(data);
			bindEMPAutoComplete(obj);
		}
	});
	GetLocalWeather(latitude, longitude);
});
function parseOutput(obj){
	var url = "http://en.wikipedia.org/w/index.php?title=" + obj[0].city.trim();
	//$("#rightHalf").append("<iframe style=' overflow:hidden;width:700px;height:400px' id='center' src='http://en.wikipedia.org/w/index.php?title=" + obj[0].city.trim()+ "'></iframe>");
	$("#leftHalf").append("<u><b><i><a href= '" + url + "'>" + obj[0].city.trim() + "</a></i></b></u>");
	$("#leftHalf").append("<br/>Latitude: <b><i>" + obj[0].city_latitude + "</i></b>");
	$("#leftHalf").append("<br/>Longitude: <b><i>" + obj[0].city_longitude + "</i></b>");
	$("#leftHalf").append("<br/>Purchasing Power Index: <b><i>" + obj[0].cost_index + "</i></b>");
	$("#leftHalf").append("<br/>Safety Index: <b><i>" + obj[0].crime_index + "</i></b>");
	$("#leftHalf").append("<br/>Health Index: <b><i>" + obj[0].health_index + "</i></b>");
	$("#leftHalf").append("<br/>Environment Index: <b><i>" + obj[0].pollution_index + "</i></b>");
	$("#leftHalf").append("<br/>Affordability Index: <b><i>" + obj[0].property_index + "</i></b>");
	$("#leftHalf").append("<br/>Employment Index: <b><i>" + obj[0].employment_index + "</i></b>");
	var title = String(obj[0].city);
	if(title.indexOf('Buffalo') > -1)
		title = 'Buffalo, United States';
	else if(title.indexOf('Hyderabad') > -1)
		title = 'Hyderabad';
	else if(title.indexOf('Aberdeen') > -1)
		title = 'Aberdeen';
	else if(title.indexOf('Canberra') > -1)
		title = 'Canberra';
	else if(title.indexOf('Ottawa') > -1)
		title = 'Ottawa';
	else if(title.indexOf('Windsor') > -1)
		title = 'Windsor, Ontario';
	else if(title.indexOf('Cork') > -1)
		title = 'Cork (city)';
	else if(title.indexOf('Caracas') > -1)
		title = 'Caracas';
	else if(title.indexOf('Vancouver') > -1)
		title = 'Vancouver';	
	else if(title.indexOf('Phoenix') > -1)
		title = 'Phoenix, Arizona';	
	else if (title.count(',') >= 2)
		title = obj[0].city.split(',')[0];
	var pageId = 0;
	$.getJSON("http://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&titles="+title+"&format=json&callback=?", function(data) {
	    pageId = doSomethingWith(data);
		var url = "http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&page="+pageId+"&callback=?";
		$.getJSON(url, function(data) {
		    successCall(data);
		    if( $('#rightHalf').text().length < 200)
				$('#rightHalf').append("<iframe id='center' style='width:700px;height:400px' src='http://en.wikipedia.org/w/index.php?title=" + obj[0].city.trim() + "'></iframe>");

		});
	});
}
function doSomethingWith(data){
	if (data && data.query && data.query.pages)
    	var pages = data.query.pages;
	else{}
    	// error: No pages returned / other problems!
	for (var id in pages) { // in your case a loop over one property
    	if (pages[id].revisions && pages[id].revisions[0] && pages[id].revisions[0]["*"]){
			var content = pages[id].revisions[0]["*"];
			var red = String(content.split('\n')[0]);
			if(red.toLowerCase().indexOf('#redirect') > -1){
				red = replaceAll(red, '#redirect','',true);
				red = red.replace('[[','');
				red = red.replace(']]','');
				return red.trim();
			}
			return pages[id].title;        		
        	break;
    	}
    	else{}
        	// error: No revision content returned for whatever reasons!
	}
}
function successCall(data){
		if (data && data.query && data.query.pages)
	    	var pages = data.query.pages;
		else{}
	    	// error: No pages returned / other problems!
		for (var id in pages) { // in your case a loop over one property
	    	if (pages[id].revisions && pages[id].revisions[0] && pages[id].revisions[0]["*"]){
	        	var content = pages[id].revisions[0]["*"];
	        	break;
	    	}
	    	else{}
	        	// error: No revision content returned for whatever reasons!
		}
		var markup = data.parse.text["*"];
       	var blurb = $('<div></div>').html(markup);

       // remove links as they will not work
       blurb.find('a').each(function() { $(this).replaceWith($(this).html()); });

       // remove any references
       blurb.find('sup').remove();

       // remove cite error
       blurb.find('.mw-ext-cite-error').remove();
       $('#rightHalf').html($(blurb).find('p'));
}

function bindPOPAutoComplete(obj){
	google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawPOPChart);
    drawPOPChart(obj);
}
function bindAutoComplete(obj){
	google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawChart);
    drawChart(obj);
}
function bindEMPAutoComplete(obj){
	google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawEMPChart);
    drawEMPChart(obj);
}
function drawPOPChart(obj) {
    var data = google.visualization.arrayToDataTable([
      ['Year', obj[0].city],
      ['2003',  obj[0].popdens_2000],
      ['2004',  obj[0].popdens_2001],
      ['2005',  obj[0].popdens_2002],
      ['2006',  obj[0].popdens_2003],
      ['2007',  obj[0].popdens_2004],
      ['2008',  obj[0].popdens_2005],
      ['2009',  obj[0].popdens_2006],
      ['2010',  obj[0].popdens_2007],
      ['2011',  obj[0].popdens_2008],
      ['2012',  obj[0].popdens_2009],
      ['2013',  obj[0].popdens_2010],
    ]);

    var options = {
      title: 'City Population Density',
      width: 500,
      height: 270,
      vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
    };

    var chart = new google.visualization.BarChart(document.getElementById('chart_pop_div'));

    chart.draw(data, options);
  }
function drawEMPChart(obj) {
    var data = google.visualization.arrayToDataTable([
      ['Year', obj[0].city],
      ['2001',  obj[0].employment_2000],
      ['2002',  obj[0].employment_2001],
      ['2003',  obj[0].employment_2002],
      ['2004',  obj[0].employment_2003],
      ['2005',  obj[0].employment_2004],
      ['2006',  obj[0].employment_2005],
      ['2007',  obj[0].employment_2006],
      ['2008',  obj[0].employment_2007],
      ['2009',  obj[0].employment_2008],
      ['2010',  obj[0].employment_2009],
      ['2011',  obj[0].employment_2010],
      ['2012',  obj[0].employment_2011],
      ['2013',  obj[0].employment_2012]
    ]);

    var options = {
      title: 'City Employment (Persons)',
      width: 500,
      height: 270,
      vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
    };

    var chart = new google.visualization.BarChart(document.getElementById('chart_employment_div'));

    chart.draw(data, options);
  }
function drawChart(obj) {
    var data = google.visualization.arrayToDataTable([
      ['Year', obj[0].city],
      ['2003',  obj[0].percapita_2000],
      ['2004',  obj[0].percapita_2001],
      ['2005',  obj[0].percapita_2002],
      ['2006',  obj[0].percapita_2003],
      ['2007',  obj[0].percapita_2004],
      ['2008',  obj[0].percapita_2005],
      ['2009',  obj[0].percapita_2006],
      ['2010',  obj[0].percapita_2007],
      ['2011',  obj[0].percapita_2008],
      ['2012',  obj[0].percapita_2009],
      ['2013',  obj[0].percapita_2010],
    ]);

    var options = {
      title: 'City PerCapita',
      width: 500,
      height: 270,
      vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
    };

    var chart = new google.visualization.BarChart(document.getElementById('chart_div'));

    chart.draw(data, options);
  }
function GetLocalWeather(latitude, longitude) {
    var localWeatherInput = {
        query: latitude+','+longitude,
        format: 'JSON',
        num_of_days: '1',
        date: '',
        fx: '',
        cc: '',
        tp: '',
        includelocation: '',
        show_comments: '',
        callback: 'LocalWeatherCallback'
    };

    JSONP_LocalWeather(localWeatherInput);
}

function LocalWeatherCallback(localWeather) {
	plotCharts(localWeather);
}
function plotCharts(localWeather) {
    var minTemp = []; 
    var maxTemp = [];
    var title = 'Weather History';
    for(i = 0; i< 12 ; i++){
	   minTemp.push(parseFloat(localWeather.data.ClimateAverages[0].month[i].absMaxTemp));
       maxTemp.push(parseFloat(localWeather.data.ClimateAverages[0].month[i].avgMinTemp));
    }
    $('#container').highcharts({
       title: {
           text: title,
           x: -20 //center
       },
       subtitle: {
           text: 'Source: WeatherUnderGround',
           x: -20
       },
       xAxis: {
           categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
               'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
       },
       yAxis: {
           title: {
               text: 'Temperature (°C)'
           },
           plotLines: [{
               value: 0,
               width: 1,
               color: '#008080'
           }]
       },
       tooltip: {
           valueSuffix: '°C'
       },
       legend: {
           layout: 'vertical',
           align: 'right',
           verticalAlign: 'middle',
           borderWidth: 0
       },
       series: [{
           name: 'Absolute Max',
           data: minTemp
       }, {
           name: 'Avg Min',
           data: maxTemp
       }]
   });
 }
function replaceAll(_s, _f, _r, _c){ 

	  var o = _s.toString();
	  var r = '';
	  var s = o;
	  var b = 0;
	  var e = -1;
	  if(_c){ _f = _f.toLowerCase(); s = o.toLowerCase(); }

	  while((e=s.indexOf(_f)) > -1)
	  {
	    r += o.substring(b, b+e) + _r;
	    s = s.substring(e+_f.length, s.length);
	    b += e+_f.length;
	  }

	  // Add Leftover
	  if(s.length>0){ r+=o.substring(o.length-s.length, o.length); }

	  // Return New String
	  return r;
}
</script>
</html>