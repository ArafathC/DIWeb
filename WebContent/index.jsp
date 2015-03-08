<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src='http://maps.google.com/maps/api/js?sensor=false&libraries=places'></script>
<script type="text/javascript" src="scripts/jquery.ui.map.min.js"></script>
<script type="text/javascript" src="scripts/jquery-ui.min.js"></script>
<link rel="stylesheet" href="css/jquery-ui.css">
<link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
<script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="jqwidgets/jqxdropdownlist.js"></script>
<script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="jqwidgets/jqxgrid.filter.js"></script>
<script type="text/javascript" src="jqwidgets/jqxgrid.sort.js"></script>
<script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script>
<script type="text/javascript" src="jqwidgets/jqxpanel.js"></script>
<script type="text/javascript" src="jqwidgets/jqxcalendar.js"></script>
<script type="text/javascript" src="jqwidgets/jqxdatetimeinput.js"></script>
<script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script> 
<script type="text/javascript" src ="jqwidgets/jqxdatatable.js"></script>
<script type="text/javascript" src="jqwidgets/jqxslider.js"></script>
<script type="text/javascript" src="jqwidgets/jqxinput.js"></script>
<script type="text/javascript" src="jqwidgets/jqxradiobutton.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Best Cities to Live</title>
</head>
<body>
<table>
<tr><td>
<table><tr><td>
<table><tr><td>
 <div id='jqxRadioButton'>
            Accuracy</div></td><td>
<div  id='jqxRadioButton2'>
 			<span>Completeness</span></div>
</td></tr></table>
<input type="button" value="Re Evaluate" onclick="reevaluate()"></input></td><td>
<input id="jqxInput" />
</td></tr></table>
<div id="somecomponent" class="map rounded" style="width: 800px; height: 600px;"></div>
</td>
<td valign ="top">
<div id = "top-ten"></div>
<br/><br/>
<table style="table-layout: fixed;">
<tr><td style="width:100%">Cost of Living: </td>
<td style="width:auto;oveflow:hidden"><div id="cost-slider"></div></td></tr>
<tr><td style="width:40%">Health care:</td>
<td style="width:60%"> <div id="health-slider"></div></td></tr>
<tr><td style="width:40%">Property Prices(Affordability): </td>
<td style="width:60%"><div id="property-slider"></div></td></tr>
<tr><td style="width:40%">Pollution: </td>
<td style="width:60%"><div id="pollution-slider"></div></td></tr>
<tr><td style="width:40%">Crime Rate:</td>
<td style="width:60%"> <div id="crime-slider"></div></td></tr>
<tr><td style="width:40%">Employment Growth Rate:</td>
<td style="width:60%"> <div id="emp-slider"></div></td>
</tr></table>
</td></tr></table>
<form action = "SampleServlet">
</form>
</body>
<script type = "text/javascript">
$("#jqxRadioButton").jqxRadioButton({ width: 250, height: 25, checked: true});
$("#jqxRadioButton2").jqxRadioButton({ width: 250, height: 25});
$("#jqxRadioButton").on('change', function (event) {
    var checked = event.args.checked;
	reevaluate();
});
function reevaluate(){
	var checked = $('#jqxRadioButton').val();
	var model = 1;
	if(!checked)
		model = 0;
	$.ajax({
		url:"/DIWeb/SampleServlet",
		type:"post",
		data:{model:model,cost:$('#cost-slider').val(), health:$('#health-slider').val(), pollution:$('#pollution-slider').val(),
			 property:$('#property-slider').val(), crime:$('#crime-slider').val(), emp:$('#emp-slider').val()},
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error Occured");
		},
		success:function(data){
			var obj = jQuery.parseJSON(data);
			var i = 0;
			bindGrid(data);
			//$('#top-ten').empty();
			//$('#top-ten').append('<table border: 1px> <tr> <th text-align:left> Rank </th><th> City </th> <th> Livability Index </th> </tr>');
			$('#somecomponent').gmap('clear', 'markers');
			for( i = 0; i< obj.length; i++)
				bindMap(obj[i], i);
			$('#somecomponent').gmap('option', 'zoom', 3);
			//$('#top-ten').append('</table>');
		}
	});
}
$('#cost-slider').jqxSlider({ showButtons: false, tooltip:true, min: 0, max: 1, ticksFrequency: 0.1, value: 0.1333, step: 0.05});
$('#health-slider').jqxSlider({ showButtons: false,tooltip:true, min: 0, max: 1, ticksFrequency: 0.1, value: 0.1333, step: 0.05});
$('#property-slider').jqxSlider({showButtons: false,tooltip:true, min: 0, max: 1, ticksFrequency: 0.1, value: 0.1333, step: 0.05});
$('#pollution-slider').jqxSlider({showButtons: false,tooltip:true, min: 0, max: 1, ticksFrequency: 0.1, value: 0.1333, step: 0.05});
$('#crime-slider').jqxSlider({showButtons: false, tooltip:true, min: 0, max: 1, ticksFrequency: 0.1, value: 0.1333, step: 0.05});
$('#emp-slider').jqxSlider({showButtons: false, tooltip:true, min: 0, max: 1, ticksFrequency: 0.1, value: 0.1333, step: 0.05});

$('#somecomponent').gmap().bind('init', function() { 
	$.ajax({
		url:"/DIWeb/SampleServlet",
		type:"get",
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error Occured");
		},
		success:function(data){
			var obj = jQuery.parseJSON(data);
			var i = 0;
			bindGrid(data);
			//$('#top-ten').append('<table border: 1px> <tr> <th text-align:left> Rank </th><th> City </th> <th> Livability Index </th> </tr>');
			for( i = 0; i< obj.length; i++)
				bindMap(obj[i], i);
			$('#somecomponent').gmap('option', 'zoom', 3);
			//$('#top-ten').append('</table>');
		}
	});
});

$(document).ready(function () {
	$.ajax({
		url:"/DIWeb/SelectData",
		type:"get",
		data:{action: 'Select city data'},
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error Occured");
		},
		success:function(data){
			var obj = jQuery.parseJSON(data);
			bindAutoComplete(data);
		}
	});
});

function bindAutoComplete(data){
	var source =
    {
        dataType: "json",
        dataFields: [
            { name: 'city_id', type: 'int' },
            { name: 'city', type: 'string' },
            { name: 'city_latitude', type:'string'},
            { name: 'city_longitude', type:'string'}
        ],
        id: 'id',
        localdata : data
    };
	var dataAdapter = new $.jqx.dataAdapter(source);
	$("#jqxInput").jqxInput({ source: dataAdapter, placeHolder: "City :", displayMember: "city", valueMember: "city_id", width: 200, height: 25});
 	
	  $("#jqxInput").on('select', function (event) {
          if (event.args) {
              var item = event.args.item;
              if (item) {
                  var latitude, longitude;

                  for (var i = 0; i < dataAdapter.records.length; i++) {
                      if (item.label == dataAdapter.records[i].city) {
                          latitude = dataAdapter.records[i].city_latitude;
                          longitude = dataAdapter.records[i].city_longitude;
                          break;
                      }
                  }
                  str = "/DIWeb/CityData.jsp?Latitude="+ latitude + "&Longitude="+ longitude;
                  window.location.href = str;
              }
          }
      });
	
}

function bindGrid(data){
	var source =
    {
        dataType: "json",
        dataFields: [
            { name: 'rank', type: 'int' },
            { name: 'city', type: 'string' },
            { name: 'final_index', type: 'string' },
            { name: 'city_latitude', type:'string'},
            { name: 'city_longitude', type:'string'}
        ],
        id: 'id',
        localdata : data
    };
    var linkrenderer = function (row, column, value, rowData) {
    	var str = '';
    	str = str +"<a href = '/DIWeb/CityData.jsp?Latitude="+ 
		rowData.city_latitude + "&Longitude="+ rowData.city_longitude
		+"'>" + rowData.city + "</a>" ;
		return str;
    }

    var dataAdapter = new $.jqx.dataAdapter(source);
    $("#top-ten").jqxDataTable(
    {
        width: 450,
        pageable: true,
        pagerButtonsCount: 10,
        source: dataAdapter,
        filterable:true,
        sortable:true,
        columnsResize: true,
        columns: [
          { text: 'Rank', dataField: 'rank', width: 100 },
          { text: 'City', dataField: 'city', width: 250, cellsrenderer: linkrenderer },
          { text: 'Livability Index', dataField: 'final_index', width: 100 },
          { text: 'Latitude', dataField: 'city_latitude', width: 250, hidden: true },
          { text: 'Longitude', dataField: 'city_longitude', width: 250, hidden:true }
      ]
    });
}
function bindMap(data, i){
	var latitude = data.city_latitude;
	var longitude = data.city_longitude;
	var address = data.city;
	var str = '<div width:600px height:400px>';
	str = str +"<p> Rank :" + data.rank + "</b></p>" ;
	str = str +"<p> City : <a href = '/DIWeb/CityData.jsp?Latitude="+ 
			data.city_latitude + "&Longitude="+ data.city_longitude
			+"'>" + address + "</a></p>" ;
	str = str +"<p> Livability Index :" + data.final_index + "</b></p>" ;
	str = str + "</div>";
	$('#somecomponent').gmap('addMarker', { 
		'position': new google.maps.LatLng(latitude, longitude),
		'title' : data.city
	}).click(function() {
		$('#somecomponent').gmap('openInfoWindow', { 
			'content': str }, this);
	});
}
</script>

</html>