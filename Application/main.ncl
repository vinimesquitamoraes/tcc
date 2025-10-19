<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="prototipo" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
   <head>
	<regionBase>
          <region id="r_info" left="60%" top="0" width="40%" height="100%" zIndex="3"/>
          <region id="r_btn_anterior" left="60%" top="40%" width="5%" height="6%" zIndex="3"/>
	  <region id="r_btn_proximo" left="95%" top="40%" width="5%" height="6%" zIndex="3"/>	  
	  <region id="r_placeholder" width ="100%" height="100%" zIndex="1"/>
	  <region id="r_btn_alerta" left="85%" top="0%" width="15%" height="15%" zIndex="2"/>
	  <region id="r_btn_sair" left="94%" top="9.5%" width="6%" height="7%" zIndex="3" />
	  <region id="r_qrcode" left="88.8%" top="88.5%" width="11%" height="11%" zIndex="3"/>	  
	  
 	</regionBase>

	<descriptorBase>
          <descriptor id="dp_info" region="r_info" focusIndex="0" transIn="trans2"/>
          <descriptor id="dp_placeholder" region="r_placeholder" focusIndex="0"/>
          <descriptor id="dp_anterior" region="r_btn_anterior" focusIndex="0"/>
  	  <descriptor id="dp_proximo" region="r_btn_proximo" focusIndex="0"/>
  	  <descriptor id="dp_sair" region="r_btn_sair" focusIndex="0"/>
  	  <descriptor id="dp_qrcode" region="r_qrcode" focusIndex="0"/>
  	  <descriptor id="dp_alerta" region="r_btn_alerta" focusIndex="0" transIn="trans1"/>
	</descriptorBase>

	<connectorBase>
	  <causalConnector id="onBeginStart">
            <simpleCondition role="onBegin"/>
            <simpleAction role="start"/>
          </causalConnector>

          <causalConnector id="onEndStop">
            <simpleCondition role="onEnd"/>
            <simpleAction role="stop" max="unbounded"/>
          </causalConnector>
          
          <causalConnector id="onKeySelectionStart">
	    <connectorParam name="keyCode"/>
		<simpleCondition role="onSelection" key="$keyCode"/>
		<simpleAction role="start" max="1" qualifier="par"/>
	    </causalConnector>
         
         <causalConnector id="onKeySelectionEnd">
	    <connectorParam name="keyCode"/>
		<simpleCondition role="onSelection" key="$keyCode"/>
		<simpleAction role="stop" max="unbounded" qualifier="par"/>
	    </causalConnector>
         </connectorBase>
         
        <transitionBase>
		<transition id="trans1" type="clockWipe" dur="1s"/>
		<transition id="trans2" type="fade" dur="0.5s"/>
	</transitionBase>
	
   </head>
   
   <body>
	<port component="prototipo" id="inicio"/>

	<media id="md_info" descriptor="dp_info" src="scripts/script.lua"/>	
	<media id="md_placeholder" descriptor="dp_placeholder" src="placeholder.mp4"/>
	<media id="btn_anterior" descriptor="dp_anterior" src="anterior.png"/>
	<media id="btn_proximo" descriptor="dp_proximo" src="proximo.png"/>
	<media id="btn_alerta" descriptor="dp_alerta" src="alert.png"/>
	<media id="btn_sair" descriptor="dp_sair" src="sair_blue.png"/>
	<media id="qrcode" descriptor="dp_qrcode" src="qrcode.png"/>
	
	<link xconnector="onBeginStart">
          <bind role="onBegin" component="prototipo"/>
          <bind role="start" component="md_placeholder"/>
          <bind role="start" component="btn_alerta"/>
        </link>
        
	 <link xconnector="onKeySelectionStart">
	  <bind role="onSelection" component="btn_alerta">
	    <bindParam name="keyCode" value="RED"/>
	  </bind>
	  <bind role="start" component="md_info"/>
	  <bind role="start" component="btn_anterior"/>
          <bind role="start" component="btn_proximo"/>
          <bind role="start" component="btn_sair"/>
          <bind role="start" component="qrcode"/>
	</link>
	
	<link xconnector="onKeySelectionEnd">
	  <bind role="onSelection" component="btn_sair">
	    <bindParam name="keyCode" value="BLUE"/>
	  </bind>
	  <bind role="stop" component="btn_anterior"/>
          <bind role="stop" component="btn_proximo"/>
          <bind role="stop" component="btn_sair"/>
	  <bind role="stop" component="md_info"/>
	  <bind role="stop" component="qrcode"/>
	  <bind role="start" component="md_placeholder"/>
	  <bind role="start" component="btn_alerta"/>
	</link>

    	<link xconnector="onEndStop">
          <bind role="onEnd" component="prototipo"/>
          <bind role="stop" component="md_info"/>
          <bind role="stop" component="md_placeholder"/>
          <bind role="stop" component="btn_anterior"/>
          <bind role="stop" component="btn_proximo"/>
          <bind role="stop" component="btn_sair"/>
          <bind role="stop" component="qrcode"/>
    	</link>

   </body>
</ncl>
