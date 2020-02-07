I#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#include <KBColorizeTraces>


Menu "Macros"
	"YC Control Panel", BCMS()  
End

Function BCMS()                    //Create data folders for broad band corbino microwave spectroscopy

String dfSave = GetDataFolder(1)
String Today= Date()
NewDataFolder/O/S root:$Today 

//String FolderName = "x"
//Prompt FolderName, "Please input the name of folder here"
//DoPrompt "Name of folder", FolderName

NewDataFolder/O/S root:$Today 

	DoWindow/HIDE=? $("BCMSWindow")
	if (V_flag != 0)
		DoWindow/F BCMSWindow;
	else
		Execute/Q "BCMSWindow()"
	endif
	
SetDataFolder dfSave
	
End

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Window BCMSWindow() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1158,126,1805,717)
	SetDrawLayer UserBack
	SetDrawEnv fsize= 24
	DrawText 108,60,"Load"
	DrawLine 20,70,246,70
	SetDrawEnv fsize= 24
	DrawText 120,230,"Do"
	DrawLine 20,240,246,240
	SetDrawEnv fsize= 24
	DrawText 355,60,"Calibrate"
	DrawLine 290,70,516,70
	SetDrawEnv fsize= 24
	DrawText 355,310,"Calculate"
	DrawLine 290,320,516,320
	SetDrawEnv fsize= 24
	DrawText 355,510,"SaveData"
	DrawLine 290,520,516,520
	Button button0,pos={43,80},size={180,40},proc=LbNProc,title="LoadbyReIm"
	Button button1,pos={43,130},size={180,40},proc=LNMProc,title="LoadbyMagPhs"
	Button button36,pos={233,130},size={40,40},proc=LoadOneTempProc,title="LoadOneT"
	Button button43,pos={233,180},size={40,40},proc=LoadOneTemp1Proc,title="AvgOne"
	Button button37,pos={274,130},size={40,40},proc=ErrTerm1Proc,title="ErrT1"
	Button button3,pos={43,260},size={180,40},proc=IntProc,title="DoInterpolation"
	Button button4,pos={43,310},size={180,40},proc=DupTFProc,title="DuplicateTandF"
	Button button23,pos={233,310},size={40,40},proc=TFieldProc,title="CalT"
	Button button5,pos={43,360},size={180,40},proc=M2CalProc,title="Move2Calibrations"
	Button button27,pos={233,360},size={40,40},proc=CutProc,title="Cut"
	Button button6,pos={43,410},size={180,40},proc=OneTProc,title="OneTempPnt"
	Button button21,pos={233,410},size={40,40},proc=AvgTProc,title="AvgT"
	Button button22,pos={274,410},size={40,40},proc=AvgFProc,title="AvgF"
	Button button8,pos={43,460},size={180,40},proc=GS22Proc,title="GetS22"
	Button button16,pos={233,260},size={40,40},proc=V2RProc,title="VtoR"
	Button button17,pos={43,510},size={80,40},proc=Fconverter,title="CvtF"
	Button button9,pos={315,80},size={180,40},proc=CrOSProc,title="CorrectOfffset"
	Button button10,pos={315,130},size={180,40},proc=CrBGProc,title="CorrectBackground"
	Button button11,pos={315,180},size={85,40},proc=CrSbProc,title="CorrSub"
	Button button31,pos={410,180},size={85,40},proc= CorrSubNProc,title="CSNorm"
	Button button12,pos={405,230},size={85,40},proc=CaErrProcSC,title="ErrTrmsSC"
	Button button14,pos={315,330},size={180,40},proc=CalSpProc,title="CalSampleA"
	Button button15,pos={315,380},size={180,40},proc=CalStProc,title="CalStiff"
	Button button20,pos={315,430},size={180,40},proc=ExtDrudeProc,title="ExtDrude"
	Button button18,pos={315,530},size={85,40},proc=SaveXY,title="SaveXY"
	//Button button23, pos={495, 530}, size={40,40},proc=SV2CXProc,title="CX"
	Button button24, pos={495, 530}, size={40,40},proc=	CombineCXProc,title="CB"	
	Button button26, pos={495,230}, size={40,40}, proc=ErrIntProc, title = "IntE"	
	Button button28, pos={495,380},size={40,40},proc=StProc, title = "single"
	Button button30, pos={495,430},size={40,40},proc=IntRangeProc, title = "Ingr"	
	Button button32, pos={274,230},size={40,40},proc= ShrtProc, title = "DSht"	//duplicate short calibration 
	Button button33, pos={315,230},size={85,40},proc=CaErrProcN,title="ErrTrmsNorm"
	Button button34, pos={133,510}, size={80,40}, proc=DPlotProc, title="Decmp"	
	button button35, pos={410,530},size={85,40},proc=SvThermalProc, title="Save2D"
	Button button39,pos={495,330},size={40,40},proc=Cal1TProc,title="Sam1T"		
	Button button40, pos={495,180},size={40,40}, proc=CSNorm1Proc, title="CSN1"
	Button button41, pos={274, 180}, size={40,40},proc=CalErrProcSC1,title="ErrSC1"
	Button button42, pos ={545,180}, size={40,40},proc=IntpSubProc,title="IntSub"
	Button button44, pos={545,330}, size ={40, 40}, proc=  CalSaProc, title ="CalSa"
	Button button45, pos={595,330}, size ={40, 40}, proc=  AvgWvProc, title ="AvgWv"
EndMacro


Function LbNProc(ba) : ButtonControl  //define the buttons 
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			LoadbyReIm()
			break
	endswitch

	return 0
End


Function LNMProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			 LoadbyMagPhs()
			break
	endswitch

	return 0
End

Function GS22Proc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			 Con2Mag()
			break
	endswitch

	return 0
End

Function IntProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			DoInterpolation()
			break
	endswitch

	return 0
End



Function CrOSProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CorrectOffset()
			break
	endswitch

	return 0
End

Function CrBGProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CorrectBackground()
			break
	endswitch

	return 0
End

Function CrSbProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CorrectSubstrate()
			break
	endswitch

	return 0
End

Function CaErrProcSC(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CalculateErrTermsSC()
			break
	endswitch

	return 0
End


Function CaErrProcN(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CalculateErrTermsN()
			break
	endswitch

	return 0
End

Function RTCaErrProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			RTErrTerms()
			break
	endswitch

	return 0
End

Function CalSpProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CalSampleA()
			break
	endswitch

	return 0
End

Function CalStProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CalStiff()
			break
	endswitch

	return 0
End


Function M2CalProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Move2Cal()
			break
	endswitch

	return 0
End

Function DupTFProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			DuplicateTandF()
			break
	endswitch

	return 0
End

Function OneTProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			OneTempPnt()
			break
	endswitch

	return 0
End

Function ImPartProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			ImagPart()
			break
	endswitch

	return 0
End

Function V2RProc(ba) : ButtonControl //define the buttons
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			VtoR()
			break
	endswitch

	return 0
End

Function  Fconverter(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			F2WNo()
			break
	endswitch

	return 0
End

Function  SaveXY(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			SV2WVS()
			break
	endswitch

	return 0
End


Function  ExtDrudeProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			ExtDrude()
			break
	endswitch

	return 0
End


Function  AvgTProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Avg_T()
			break
	endswitch

	return 0
End

Function  AvgFProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Avg_F()
			break
	endswitch

	return 0
End

Function TFieldProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			TempField()
			break
	endswitch

	return 0
End

Function SV2CXProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			SV2CX()
			break
	endswitch

	return 0
End


Function CombineCXProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CombineCX()
			break
	endswitch

	return 0
End



Function ErrIntProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			 IntpErrTerms()
			break
	endswitch

	return 0
End


Function CutProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			CutData()
			break
	endswitch

	return 0
End

Function StProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			  Stiffsingle()
			break
	endswitch

	return 0
End

Function IntRangeProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   IntRange()
			break
	endswitch

	return 0
End


Function CorrSubNProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			  CorrSubfromNorm()
			break
	endswitch

	return 0
End

Function ShrtProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			  DupShort()
			break
	endswitch

	return 0
End

Function DPlotProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			  Dep4Plot()
			break
	endswitch

	return 0
End


Function SvThermalProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   SVThermal()
			break
	endswitch

	return 0
End

Function LoadOneTempProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   LoadOneTemp()
			break
	endswitch

	return 0
End


Function ErrTerm1Proc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   CalErrOneT()
			break
	endswitch

	return 0
End

Function Cal1TProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   CalSam1T()
			break
	endswitch

	return 0
End

Function CSNorm1Proc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   CorrSubfromNorm1()
			break
	endswitch

	return 0
End

Function CalErrProcSC1(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			  CalculateErrTermsSC1()
			break
	endswitch

	return 0
End

Function  IntpSubProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   IntpSub()
			break
	endswitch

	return 0
End

Function LoadOneTemp1Proc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   LoadOneTemp1() 
			break
	endswitch

	return 0
End

Function CalSaProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   CalSa() 
			break
	endswitch

	return 0
End

Function AvgWvProc(ba): ButtonControl
 	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			   AvgWave() 
			break
	endswitch

	return 0
End



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Function LoadbyReIm()      //a function, Load by Name
	String Makex="no"
	Prompt  Makex, "Make x wave?", popup "yes;no"
	Doprompt "Make x wave?", Makex
	
	Variable refNum, i, j, fullpathlength, NFreqPnts
	String message="Select a file"
	String filePath, theFile, junk, thePath, theDataDir, thePrefix, S11File
	Open/R/M=message/Z=2 refNum
	filePath=S_filename
	FReadLine refNum, junk
	
	i=0
	fullpathlength=strlen(filePath)
	
	Do
		i=i+1
	while(!(stringmatch(filePath[fullpathlength-1-i,fullpathlength-1-i],":")))
	
	thePath=filePath[0,fullpathlength-1-i]
	theDataDir=filePath[fullpathlength-i,fullpathlength-5]
	thePrefix=filePath[fullpathlength-i,fullpathlength-15]
        
       String Today = Date()
        SetDatafolder root:$Today
        NewDataFolder/O/S:$theDataDir
                
	i=0
	j = strsearch(theDataDir,"T",0)
	string FrequencyRange=theDataDir[0,j-1]+"FrequencyRange"
	
	//Loading TemperatureFile

	LoadWave/J/W/A/Q/V={"\t"," $",0,1}/L={0,1,0,0,6}/B="c=1,F=-2; c=3, F=0;" filePath		
	String/G FileNames =theDatadir + "_Time"
	Rename $StringFromList(0, S_waveNames), $FileNames
	FileNames =theDatadir+ "_"+StringFromList(1, S_waveNames)
	Rename $StringFromList(1, S_waveNames), $FileNames
	FileNames = theDataDir + "_"+StringFromList(2, S_waveNames)
	Rename $StringFromList(2, S_waveNames), $FileNames
	FileNames = theDataDir + "_"+StringFromList(3, S_waveNames)
	Rename $StringFromList(3, S_waveNames), $FileNames

	//Loading TemperatureFile above
	

	Do		
		FReadLine/T="\t" refNum, theFile		// Read first line into string variable
		FReadLine refNum, junk
		
		theFile= theFile[0,strlen( theFile)-2]
				
		If (strlen(theFile) == 0)
			break
		endif		
			
	
		theFile= theFile + ".s1p"
		theFile = thePath +thePrefix+ theFile
		
		LoadWave/J/A/Q/K=0/V={" "," $",0,1}/L={0,6,0,0,3} theFile	

		String/G Frequency="frequency_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]
		Rename $StringFromList(0, S_waveNames), $Frequency
		WaveStats/Q $Frequency
		NFreqPnts=V_npnts
		
		String/G RealPart="realpart_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]
		Rename $StringFromList(1,S_waveNames), $RealPart
		String/G ImaginaryPart="imaginarypart_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]
		Rename $StringFromList(2,S_waveNames), $ImaginaryPart

		S11File=theDataDir[0,j-1]+"S11_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]

		Make/C/O/N=(NFreqPnts)/D $S11File
		wave Lreal=$RealPart, Limaginary=$ImaginaryPart
		wave/C S11=$S11File
		S11=cmplx(Lreal, Limaginary)
		Killwaves $RealPart, $ImaginaryPart
		
		If  (stringmatch(Makex, "no" ))
		SetScale/I x V_min,V_max,"Hz", $S11File
		endif

		if(i==0)
		Rename $Frequency $FrequencyRange
		elseif (i!=0)
		Killwaves $Frequency
		endif

		
		i += 1
		
	while( 1)

		close refNum
		//setDataFolder root:$theDataDir
		

End


Function LoadbyMagPhs()
String Makex="no"
	Prompt  Makex, "Make x wave?", popup "yes;no"
	Doprompt "Make x wave?", Makex
	
	Variable refNum, i, j, fullpathlength, NFreqPnts
	String message="Select a file"
	String filePath, theFile, junk, thePath, theDataDir, thePrefix, S11File
	Open/R/M=message/Z=2 refNum
	filePath=S_filename
	FReadLine refNum, junk
	
	i=0
	fullpathlength=strlen(filePath)
	
	Do
		i=i+1
	while(!(stringmatch(filePath[fullpathlength-1-i,fullpathlength-1-i],":")))
	
	thePath=filePath[0,fullpathlength-1-i]
	theDataDir=filePath[fullpathlength-i,fullpathlength-5]
	thePrefix=filePath[fullpathlength-i,fullpathlength-15]

	  String Today = Date()
	  SetDatafolder root:$Today
        NewDataFolder/O/S:$theDataDir

	i=0
	j = strsearch(theDataDir,"T",0)
	string FrequencyRange=theDataDir[0,j-1]+"FrequencyRange"
	
	//Loading TemperatureFile

	LoadWave/J/W/A/Q/V={"\t"," $",0,1}/L={0,2,0,0,24}/B="c=1,F=-2; c=3, F=0;" filePath		
	String/G FileNames =theDatadir + "_Time"
	Rename $StringFromList(0, S_waveNames), $FileNames
	FileNames =theDatadir+ "_"+StringFromList(1, S_waveNames)
	Rename $StringFromList(1, S_waveNames), $FileNames
	FileNames = theDataDir + "_"+StringFromList(2, S_waveNames)
	Rename $StringFromList(2, S_waveNames), $FileNames
	FileNames = theDataDir + "_"+StringFromList(3, S_waveNames)
	Rename $StringFromList(3, S_waveNames), $FileNames
	FileNames = theDataDir + "_"+StringFromList(4, S_waveNames)
	Rename $StringFromList(4, S_waveNames), $FileNames
	FileNames = theDataDir + "_"+StringFromList(5, S_waveNames)
	Rename $StringFromList(5, S_waveNames), $FileNames

	//Loading TemperatureFile above
	

	Do		
		FReadLine/T="\t" refNum, theFile		// Read first line into string variable
		FReadLine refNum, junk
		
		theFile= theFile[0,strlen( theFile)-2]
				
		If (strlen(theFile) == 0)
			break
		endif		
			
	
		theFile= theFile + ".s1p"
		theFile = thePath +thePrefix+ theFile
		
		LoadWave/J/A/Q/K=0/V={" "," $",0,1}/L={0,6,0,0,3} theFile	

		String/G Frequency="frequency_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]
		Rename $StringFromList(0, S_waveNames), $Frequency
		WaveStats/Q $Frequency
		NFreqPnts=V_npnts
		
		String/G Mag="Mag_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]
		Rename $StringFromList(1,S_waveNames), $Mag
		String/G Phase="Phase_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]
		Rename $StringFromList(2,S_waveNames), $Phase

		Make/O/N=(NFreqPnts)/D Realpart, Imaginarypart

		S11File=theDataDir[0,j-1]+"S11_"+S_Filename[strlen(S_Filename)-16,strlen(S_Filename)-5]

		Make/C/O/N=(NFreqPnts)/D $S11File
		wave Lmag=$Mag, Lphase=$Phase, Lreal=Realpart, Limaginary=Imaginarypart
		Lreal=Lmag*cos(Lphase*Pi/180)
		Limaginary=Lmag*sin(Lphase*Pi/180)
		wave/C S11=$S11File
		S11=cmplx(Lreal, Limaginary)
		Killwaves $Mag, $Phase
		
		If  (stringmatch(Makex, "no" ))
		SetScale/I x V_min,V_max,"Hz", $S11File
		endif

		if(i==0)
		Rename $Frequency $FrequencyRange
		elseif (i!=0)
		Killwaves $Frequency
		endif

		
		i += 1
		
	while( 1)


		Killwaves  Lreal, Limaginary
		close refNum
		//setDataFolder root:$theDataDir
		

End


Function GetS11()
       
	String Files, TempFilename
	Variable FreqNo=280
	
	Prompt Files, "Choose the filenames file:", popup, Wavelist("*Time*",";","DIMS:1")
	Prompt TempFilename, "Choose the temperature file:", popup, Wavelist("*Sample*",";","DIMS:1") 
	Prompt FreqNo, "Enter the number of frequency to get S11 data"
	Doprompt "Choose the file and enter the frequency number", Files, TempFilename, FreqNo

	variable NumFiles, i, j, k,m
	String S11File, S11Filenames
	
	WaveStats/Q $TempFilename
	NumFiles = V_npnts
	print NumFiles
	Wave/T Filenames=$Files

	i = strsearch(Files,"T",0)
	S11File = Files[0,i-1]+"S11_"+num2str(FreqNo)
	S11Filenames=Files[0,i-1]+"S11_"+Filenames[0]

	Make/O/N=(NumFiles)/C/D $S11File


	Wave/C LS11File=$S11File


		k=0
		Do
			S11Filenames=Files[0,i-1]+"S11_"+Filenames[k]
			Wave/C S11_Old=$S11Filenames
			LS11File[k] =S11_Old[FreqNo]

		 	k=k+1
		while (k  < NumFiles ) 


End

Function DoInterpolation()
      String Files, TempFilename, Resistance
	Variable NTempPnts=100
	Prompt Files, "Choose the filenames file:", popup, Wavelist("*Time*",";","DIMS:1")
	Prompt TempFilename, "Choose the temperature file:", popup, Wavelist("*Sample*",";","DIMS:1")
	Prompt Resistance, "Choose the resistance file",popup, Wavelist("*Res*",";","DIMS:1")
	Prompt NTempPnts, "Enter the number of temperature points"
	Doprompt "Choose the files to be interpolated", Files, TempFilename, Resistance, NTempPnts

	variable NumFiles, i, j, k,m, n, NFreqPnts, LowerTemp,UpperTemp
	String FreqFile, S11Filenames, S11TempInt, S11Old, S11OldReal, S11OldImag
	String S11New,S11NewReal, S11NewImag, S11TempNew, ResNew
	
	WaveStats/Q $TempFilename
	NumFiles = V_npnts
	UpperTemp = V_max
	LowerTemp =  V_min
	Wave/T Filenames=$Files
	Wave Temp = $TempFilename
	
	i = strsearch(Files,"T",0)
	FreqFile = Files[0,i-1]+"FrequencyRange"
	j=strsearch(Files,"T",Inf,1)
	
	WaveStats/Q $FreqFile
	NFreqPnts=V_npnts
	
//	S11TempInt = Files[0,j-1]+"NP"+num2str(NTempPnts)+"_Int"
	S11TempInt = Files[0,j-1]+"NP"+"_Int"	
	S11Old=Files[0,i-1]+"S11_Old"
	S11OldReal= Files[0,i-1]+"S11_Old_Real"
	S11OldImag=Files[0,i-1]+"S11_Old_Imag"
	S11New=Files[0,i-1]+"S11_New"
	S11NewReal=Files[0,i-1]+"S11_New_Real"
	S11NewImag=Files[0,i-1]+"S11_New_Imag"
//	S11TempNew=Files[0,j-1]+"NP"+num2str(NTempPnts)+"_TN"
//	ResNew=Files[0,j-1]+"NP"+num2str(NTempPnts)+"_RN"
	S11TempNew=Files[0,j-1]+"NP"+"_TN"
	ResNew=Files[0,j-1]+"NP"+"_RN"
	
	S11Filenames=Files[0,i-1]+"S11_"+Filenames[0]

	Make/O/N=(NFreqPnts, NTempPnts)/C/D $S11TempInt
	SetScale/I y Lowertemp, UpperTemp, "", $S11TempInt
	SetScale/P x leftx($S11Filenames), deltax($S11Filenames),"", $S11TempInt
	
	Make/O/N=(NTempPnts) $ResNew	
	Interpolate2/T=1/N=(NTempPnts)/Y=$ResNew/X=$S11TempNew $TempFilename, $Resistance
	SetScale/I x Lowertemp, UpperTemp, "", $ResNew

	Make/O/N=(NumFiles)/C/D $S11Old
	Make/O/N=(NumFiles)/D $S11OldReal, $S11OldImag

	Make/O/N=(NTempPnts)/C/D $S11New
	Make/O/N=(NTempPnts)/D $S11NewReal, $S11NewImag

	Make/O/N=(NTempPnts)/C $S11TempNew
	
	Wave/C LS11TempInt=$S11TempInt, LS11Old=$S11Old, LS11New=$S11New
	Wave LS11TempNew=$S11TempNew, LRS11Old=$S11OldReal, LIS11Old=$S11OldImag
	Wave LRS11New=$S11NewReal, LIS11New=$S11NewImag

	m=0
	Do 
		k=0
		Do
			S11Filenames=Files[0,i-1]+"S11_"+Filenames[k]
			Wave/C S11_Old=$S11Filenames
			LS11Old[k] =S11_Old[m]

		 	k=k+1
		while (k  < NumFiles ) 
		LRS11Old=real(LS11Old)
		LIS11Old=Imag(LS11Old)

		Interpolate2/N=(NTempPnts)/Y=$S11NewReal/X=$S11TempNew $TempFilename, $S11OldReal 
		Interpolate2/N=(NTempPnts)/Y=$S11NewImag/X=$S11Tempnew $TempFilename, $S11OldImag

		LS11New = cmplx(LRS11New, LIS11New)
		LS11TempInt[m][] = LS11New[q]

		m=m+1

	while (m < NFreqPnts )
	
	//String currentdatafolder = GetDataFolder(1)	
	//String newwave = Nameofwave($S11TempInt) + "C"
	//String newwave1 = Nameofwave($S11TempNew) + "C"
	//String newwave2 = Nameofwave($ResNew) + "C"
	//Duplicate/O $S11TempInt,  $newwave
	//Duplicate/O $S11TempNew, $newwave1
	//Duplicate/O $ResNew, $newwave2
      //NewDataFolder/O/S root:CALIBRATIONS
       //String destination =  GetDataFolder(1)	
       //Setdatafolder currentdatafolder
      //MoveWave $newwave, $destination
      //MoveWave $newwave1, $destination
      //MoveWave $newwave2, $destination

      String currentdatafolder = GetDataFolder(1)	
	
      Wave newwave1, newwave2, newwave3 
      Duplicate/O $S11TempInt, newwave1
	Duplicate/O $S11TempNew, newwave2
	Duplicate/O $ResNew, newwave3
	
      NewDataFolder/O/S root:Calibrations
      String destination =  GetDataFolder(1)	
      Setdatafolder currentdatafolder
      MoveWave newwave1, $destination
      MoveWave newwave2, $destination
      MoveWave newwave3, $destination
      
	String w1 = Nameofwave($S11TempInt)
	String w2 = Nameofwave($S11TempNew)
	String w3 = Nameofwave($ResNew)
	Rename newwave1,  $w1
	Rename newwave2,  $w2
      Rename newwave3,  $w3

	Killwaves $S11Old, $S11New, $S11OldReal, $S11OldImag, $S11NewReal, $S11NewImag

End



Function CorrectOffset()

	SetDataFolder Root:Calibrations
       Variable Extra =0 //extra offset that can be manually implemented 
	String ShortR, LoadR
	Prompt ShortR, "Choose the resistance file for short standard", popup, Wavelist("*_RN*",";","DIMS:1")
	Prompt LoadR, "Choose the resistance file for load standard", popup, Wavelist("*_RN*",";","DIMS:1")
	Prompt Extra, "Additional manual offset"
	Doprompt "choose the file you want to get rid of the offset", ShortR, LoadR, Extra
	
	Wave LShortR=$ShortR, LLoadR=$LoadR
	LLoadR=LLoadR-LShortR - Extra

End

Function CorrectBackground()
	String InOxFile, InOxSubtract, InOxRe, InOxIm
	Prompt InOxFile, "File name", popup, Wavelist("InOx*",";","DIMS:1")
	Doprompt "Choose the wave that you want to substract the quasi-particle contribution", InOxFile
	
	Wave/C InOx = $InOxFile
	Variable i=11, j=21, m=0, k=46, t=1
	
	InOxSubtract = InOxFile +"Subtract"
	InOxRe= InOxFile +"real"
	InOxIm= InOxFile +"imag"	
	
	Make/O/N=46 $InOxRe, $InOxIm
	Wave LInOxRe = $InOxRe, LInOxIm = $InOxIm
	
	LInOxRe = real(InOx)
	LInOxIm = imag(InOx)

	Make/O/C/N=46 $InOxSubtract
	Wave/C LInOxSubtract = $InOxSubtract
	Make/O/N=(j-i+1) InOxInt
	Make/O/N=2 InOxIntold
	InOxIntold[0] = LInOxRe[i]
	InOxIntold[1] = LInOxRe[j]
	
	Do
		LInOxRe[m] = LInOxRe[m]-LInOxRe[i]
		m=m+1
	while(m < i+1 )

	m=j	
	Do 
		LInOxRe[m] = LInOxRe[m]-LInOxRe[k]
		m=m+1
	while(m<k+1)
			
	Interpolate2/T=1/N=(j-i+1)/Y=InOxInt InOxIntold 
	
	m=i+1
	Do 
		LInOxRe[m] = LInOxRe[m]-InOxInt[t]
		m=m+1
		t=t+1
	while(m<j)
			
	LInOxSubtract = cmplx (LInOxRe, LInOxIm)		
			
			
			
End

Function CorrectSubstrate()   // This can be used if you already know the impdance of the ACTUAL SUBSTRAETE!
	String  ImpedanceFile, GImpedance, SubstrateFile, GConductivity
	variable i, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta, scalefactor=ln(2.3/0.7)/2/pi
	
	Prompt ImpedanceFile, "Choose the impedance file for the sample:", popup, Wavelist("*Impedance*",";","DIMS:2")
	Prompt SubstrateFile, "Choose the substrate file:", popup, wavelist("**",";","DIMS:1")
	DoPrompt "Choose the corresponding file for the sample", ImpedanceFile, SubstrateFile
	Wave/C Impedance=$ImpedanceFile
	Wave/C Substrate=$SubstrateFile
	i = strsearch(ImpedanceFile,"I",inf, 1)
	GImpedance= ImpedanceFile[0, i-1]+"Impd_subcorr"
	GConductivity=ImpedanceFile[0, i-1]+"Cond_subcorr"
	i = strsearch(ImpedanceFile,"A",inf, 1)
	GImpedance=GImpedance + ImpedanceFile[i+1, inf]
	GConductivity=GConductivity + ImpedanceFile[i+1, inf]
	NTempPnts = DimSize($ImpedanceFile, 1)
	LowerTemp = Dimoffset($ImpedanceFile, 1)
	TempDelta =DimDelta($ImpedanceFile, 1)
	NFreqPnts = DimSize($ImpedanceFile, 0)
	FreqMin = Dimoffset($ImpedanceFile, 0)
	FreqDelta = DimDelta($ImpedanceFile, 0)


	Make/O/C/N=(NFreqPnts,NTempPnts) $GImpedance, $GConductivity
	Wave/C Impedcorr=$GImpedance, Condcorr=$GConductivity
	SetScale/P y Lowertemp, TempDelta, "", $GImpedance, $GConductivity
	SetScale/P x FreqMin, FreqDelta,"", $GImpedance, $GConductivity

	m=0
	Do
		k=0
		Do
			Impedcorr[m][k]= Impedance[m][k]/(1-Impedance[m][k]/Substrate[m][k])
			Condcorr[m][k] = conj(1/Impedcorr[m][k])
			k=k+1
		While(k<NTempPnts)
		
		m=m+1
		
	While(m<NFreqPnts)


End

Function CorrSubfromNorm() //This function is used if you start with normal state SAMPLE Impedance!
	String  ImpedanceFile, GImpedance, SubstrateFile, GConductivity
	variable i, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta, scalefactor=ln(2.3/0.7)/2/pi, SamRes = 2500
	
	Prompt ImpedanceFile, "Choose the impedance file for the sample:", popup, Wavelist("*Impedance*",";","DIMS:2") 
	Prompt SubstrateFile, "Choose the substrate file:", popup, wavelist("**",";","DIMS:1") //This "substrate" file is usually normal state sample imedance file (say 6K) 
	Prompt SamRes, "Please enter the resistance of sample in the normal state"
	DoPrompt "Choose the corresponding file for the sample", ImpedanceFile, SubstrateFile, SamRes
	Wave/C Substrate=$SubstrateFile
	Wave/C Impedance = $ImpedanceFile
	
	Make/C/N=1601 Zsam = cmplx(SamRes, 0)
	Substrate = Substrate*Zsam / (Zsam-Substrate)		
	
	i = strsearch(ImpedanceFile,"I",inf, 1)
	GImpedance= ImpedanceFile[0, i-1]+"Impd_subcorr"
	GConductivity=ImpedanceFile[0, i-1]+"Cond_subcorr"
	i = strsearch(ImpedanceFile,"A",inf, 1)
	GImpedance=GImpedance + ImpedanceFile[i+1, inf]
	GConductivity=GConductivity + ImpedanceFile[i+1, inf]
	NTempPnts = DimSize($ImpedanceFile, 1)
	LowerTemp = Dimoffset($ImpedanceFile, 1)
	TempDelta =DimDelta($ImpedanceFile, 1)
	NFreqPnts = DimSize($ImpedanceFile, 0)
	FreqMin = Dimoffset($ImpedanceFile, 0)
	FreqDelta = DimDelta($ImpedanceFile, 0)


	Make/O/C/N=(NFreqPnts,NTempPnts) $GImpedance, $GConductivity
	Wave/C Impedcorr=$GImpedance, Condcorr=$GConductivity
	SetScale/P y Lowertemp, TempDelta, "", $GImpedance, $GConductivity
	SetScale/P x FreqMin, FreqDelta,"", $GImpedance, $GConductivity

	m=0
	Do
		k=0
		Do
			Impedcorr[m][k]= Impedance[m][k]/(1-Impedance[m][k]/Substrate[m][k])
			Condcorr[m][k] = conj(1/Impedcorr[m][k])
			k=k+1
		While(k<NTempPnts)
		
		m=m+1
		
	While(m<NFreqPnts)
End


Function CalculateErrTermsSC()
string NDataSet="1"
	prompt NDataSet, "Data Set Number:"
	DoPrompt "Please input the number of the error terms set", NDataSet
	
	Variable i, j, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta
	String OpenFileM, ShortFileM, LoadFileM, TempFile, LoadR, Sigma2
	
	SetDataFolder Root:Calibrations

	Prompt OpenFileM, "Choose the file for open standard:", popup, Wavelist("*Int*",";","DIMS:2")
	Prompt ShortFileM, "Choose the file for short standard:", popup, Wavelist("*Int*",";","DIMS:2")
	Prompt LoadFileM, "Choose the file for load standard:", popup, Wavelist("*Int*",";","DIMS:2")
	Doprompt "Choose the interpolated files for calibration standards", OpenFileM, ShortFileM, LoadFileM
	Wave/C OpenM=$OpenFileM, ShortM=$ShortFileM, LoadM=$LoadFileM
	
	Prompt Sigma2, "Choose the file for fitted imag part of SC", popup, Wavelist("**",";","DIMS:1")
	Doprompt "Choose the file for fitted imag part of SC",Sigma2
	Wave/C FitS2 = $Sigma2
	Variable gfactor = 2*Pi/ln(2.3/0.7)

	NTempPnts = DimSize($OpenFileM, 1)
	LowerTemp = Dimoffset($OpenFileM, 1)
	TempDelta =DimDelta($OpenFileM, 1)
	NFreqPnts = DimSize($OpenFileM, 0)
	FreqMin = Dimoffset($OpenFileM, 0)
	FreqDelta = DimDelta($OpenFileM, 0)

	Variable  Z0=50, ZL
	Variable/C OpenA=cmplx(1.0, 0), ComDen
	Make/C/N=(NFreqPnts) ShortA = cmplx(-1.0, 0), Zs = cmplx(0, 0)
	Zs = (1/FitS2) * cmplx(0, 1) /gfactor   //Impedance of SC Short is SC. 
	
	for(i=0;i<(NFreqPnts);i=i+1) 
	ShortA[i] = (Zs[i] - Z0)/(Zs[i] + Z0)
	endfor 
	
	String GLoadA, GShortA

	i=strsearch(ShortFileM, "I", Inf, 1)
	GShortA = ShortFileM[0, i-1]+"A"	
	i=strsearch(LoadFileM, "I", Inf, 1)
	GLoadA = LoadFileM[0, i-1]+"A"
	LoadR = LoadFileM[0, i-1]+"RN"
	Wave LLoadR=$LoadR
	Make/O/N=(NFreqPnts, NTempPnts)/C $GLoadA
	SetScale/P y Lowertemp, TempDelta, "", $GLoadA
	SetScale/P x FreqMin, FreqDelta,"", $GLoadA
	Wave/C LoadA=$GLoadA
	j=0
	Do
		ZL = (LLoadR[j]-Z0)/(LLoadR[j]+Z0)
		LoadA[][j] = cmplx(ZL, 0)
		j+=1
	While(j<NTempPnts)
	
	Newdatafolder/O/S root:ErrorTerms
	SetDataFolder root:ErrorTerms
	
	string ErrorS, ErrorD, ErrorR
	ErrorS="ES_DataSet_"+NDataSet
	ErrorD="ED_DataSet_"+NDataSet
	ErrorR="ER_DataSet_"+NDataSet
	Make/O/N=(NFreqPnts, NTempPnts)/C/D $ErrorS, $ErrorD, $ErrorR
	SetScale/P y Lowertemp, TempDelta, "", $ErrorS, $ErrorD, $ErrorR
	SetScale/P x FreqMin, FreqDelta,"", $ErrorS, $ErrorD, $ErrorR

	Wave/C LErrorS=$ErrorS, LErrorD=$ErrorD, LErrorR=$ErrorR
	string InfoNote=OpenFileM+", "+ShortFileM+", "+LoadFileM
	Note $ErrorS, InfoNote
	Note $ErrorD, InfoNote
	Note $ErrorR, InfoNote
	
	m=0
	Do
		k=0
		Do
		
			ComDen = OpenM[m][k]*OPenA*LoadA[m][k]-OpenA*OpenM[m][k]*ShortA[m]-OpenA*LoadM[m][k]*LoadA[m][k]
			ComDen += -ShortM[m][k]*ShortA[m]*LoadA[m][k]+ShortA[m]*LoadM[m][k]*LoadA[m][k]+OpenA*ShortA[m]*ShortM[m][k]
			//print/D ComDen

		
			LErrorS[m][k] = ShortA[m]*LoadM[m][k]-LoadM[m][k]*OpenA+OpenM[m][k]*LoadA[m][k]
			LErrorS[m][k] += -ShortM[m][k]*LoadA[m][k]-OpenM[m][k]*ShortA[m]+OpenA*ShortM[m][k]
			LErrorS[m][k] /=ComDen
			//Print/D LErrorS[m][k]
		
			LErrorD[m][k] = -OpenA*OpenM[m][k]*ShortM[m][k]*LoadA[m][k]+OpenA*OpenM[m][k]*ShortA[m]*LoadM[m][k]+OpenA*LoadM[m][k]*ShortM[m][k]*LoadA[m][k]
			LErrorD[m][k] += OpenM[m][k]*LoadA[m][k]*ShortA[m]*ShortM[m][k]-OpenM[m][k]*LoadA[m][k]*ShortA[m]*LoadM[m][k]-OpenA*LoadM[m][k]*ShortA[m]*ShortM[m][k]
			LErrorD[m][k] /= -ComDen
			//Print/D LErrorD[m][k]
		
			LErrorR[m][k] = (OpenA^2) *(OpenM[m][k]^2)*ShortM[m][k]*ShortA[m]-LoadM[m][k]*(ShortM[m][k]^2)*(ShortA[m]^2)*OpenA-LoadM[m][k]*(OpenM[m][k]^2)*(OpenA^2)*ShortA[m]
			LErrorR[m][k] += -(OpenA^2)*OpenM[m][k]*(ShortM[m][k]^2)*ShortA[m]-(OpenM[m][k]^2)*(ShortA[m]^2)*ShortM[m][k]*OpenA+OpenM[m][k]*(ShortA[m]^2)*(ShortM[m][k]^2)*OpenA
			LErrorR[m][k] += -(OpenA^2)*(LoadM[m][k]^2)*ShortA[m]*ShortM[m][k]+(OpenA^2)*LoadM[m][k]*ShortA[m]*(ShortM[m][k]^2)-LoadM[m][k]*(LoadA[m][k]^2)*(ShortM[m][k]^2)*ShortA[m]
			LErrorR[m][k] += -(LoadM[m][k]^2)*(LoadA[m][k]^2)*OpenM[m][k]*ShortA[m]-(LoadM[m][k]^2)*(LoadA[m][k]^2)*ShortM[m][k]*OpenA+(LoadM[m][k]^2)*(LoadA[m][k]^2)*ShortM[m][k]*ShortA[m]
			LErrorR[m][k] += -LoadM[m][k]*(LoadA[m][k]^2)*(OpenM[m][k]^2)*OpenA+(LoadM[m][k]^2)*(LoadA[m][k]^2)*OpenM[m][k]*OpenA-(OpenA^2)*(OpenM[m][k]^2)*ShortM[m][k]*LoadA[m][k]
			LErrorR[m][k] += -OpenM[m][k]*LoadA[m][k]*(ShortA[m]^2)*(ShortM[m][k]^2)-ShortM[m][k]*(ShortA[m]^2)*LoadA[m][k]*(LoadM[m][k]^2)-OpenM[m][k]*(OpenA^2)*LoadA[m][k]*(LoadM[m][k]^2)
			LErrorR[m][k] += LoadM[m][k]*(ShortM[m][k]^2)*(ShortA[m]^2)*LoadA[m][k]+LoadM[m][k]*(OpenM[m][k]^2)*(OpenA^2)*LoadA[m][k]-(OpenM[m][k]^2)*LoadA[m][k]*(ShortA[m]^2)*LoadM[m][k]
			LErrorR[m][k] += OpenA*(OpenM[m][k]^2)*ShortM[m][k]*(LoadA[m][k]^2)-OpenA*OpenM[m][k]*(ShortM[m][k]^2)*(LoadA[m][k]^2)+(OpenA^2)*OpenM[m][k]*(ShortM[m][k]^2)*LoadA[m][k]
			LErrorR[m][k] += -OpenA*OpenM[m][k]*(ShortA[m]^2)*(LoadM[m][k]^2)+(OpenA^2)*OpenM[m][k]*ShortA[m]*(LoadM[m][k]^2)+OpenA*(OpenM[m][k]^2)*(ShortA[m]^2)*LoadM[m][k]
			LErrorR[m][k] += (OpenA^2)*(LoadM[m][k]^2)*ShortM[m][k]*LoadA[m][k]+OpenA*LoadM[m][k]*(ShortM[m][k]^2)*(LoadA[m][k]^2)-(OpenA^2)*LoadM[m][k]*(ShortM[m][k]^2)*LoadA[m][k]
			LErrorR[m][k] += -(OpenM[m][k]^2)*(LoadA[m][k]^2)*ShortA[m]*ShortM[m][k]+OpenM[m][k]*(LoadA[m][k]^2)*ShortA[m]*(ShortM[m][k]^2)+(OpenM[m][k]^2)*LoadA[m][k]*(ShortA[m]^2)*ShortM[m][k]
			LErrorR[m][k] += OpenM[m][k]*LoadA[m][k]*(ShortA[m]^2)*(LoadM[m][k]^2)+(OpenM[m][k]^2)*(LoadA[m][k]^2)*ShortA[m]*LoadM[m][k]+OpenA*(LoadM[m][k]^2)*(ShortA[m]^2)*ShortM[m][k]
			LErrorR[m][k] /= ComDen
			LErrorR[m][k] /= ComDen				
			k=k+1
		While(k<NTempPnts)
		
		m=m+1
		
	While(m<NFreqPnts)
	
	Killwaves ShortA, Zs
	
End


Function CalculateErrTermsSC1()
string NDataSet="1"
	prompt NDataSet, "Data Set Number:"
	DoPrompt "Please input the number of the error terms set", NDataSet
	
	Variable i, j, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta, LoadR=20.13, ContR =6, FacLoad = 1, FacCont =1
	String OpenFileM, ShortFileM, LoadFileM, TempFile, Sigma2
	
	SetDataFolder Root:Calibrations

	Prompt OpenFileM, "Choose the file for open standard:", popup, Wavelist("**",";","DIMS:1")
	Prompt ShortFileM, "Choose the file for short standard:", popup, Wavelist("**",";","DIMS:1")
	Prompt LoadFileM, "Choose the file for load standard:", popup, Wavelist("**",";","DIMS:1")
	Prompt LoadR, "Please enter the resistance of load"
	Prompt FacLoad, "Please enter the capactitance factor for load"
	Prompt ContR, "Please enter a contact resistance"
	Prompt FacCont, "Please enter the capactitance factor for Contact"
	Doprompt "Choose the interpolated files for calibration standards", OpenFileM, ShortFileM,  LoadFileM,LoadR, FacLoad, ContR, FacCont
	Wave/C OpenM=$OpenFileM, ShortM=$ShortFileM, LoadM=$LoadFileM
	
	Prompt Sigma2, "Choose the file for fitted imag part of SC", popup, Wavelist("**",";","DIMS:1") //loaded fitted Sigma2
	Doprompt "Choose the file for fitted imag part of SC",Sigma2
	Wave/C FitS2 = $Sigma2
	Variable gfactor = 2*Pi/ln(2.3/0.7)

	NTempPnts = DimSize($OpenFileM, 1)
	LowerTemp = Dimoffset($OpenFileM, 1)
	TempDelta =DimDelta($OpenFileM, 1)
	NFreqPnts = DimSize($OpenFileM, 0)
	FreqMin = Dimoffset($OpenFileM, 0)
	FreqDelta = DimDelta($OpenFileM, 0)

	Variable  Z0=50, ZL
	Variable/C ComDen
	Make/C/N=(NFreqPnts) ShortA = cmplx(-1.0, 0), Zs = cmplx(0, 0)
	Zs = (1/FitS2) * cmplx(0, 1) /gfactor   //Impedance of SC Short is SC. 
	
	for(i=0;i<(NFreqPnts);i=i+1) 
	ShortA[i] = (Zs[i] - Z0)/(Zs[i] + Z0)
	endfor 
	
	String GLoadA, GShortA

	//i=strsearch(ShortFileM, "I", Inf, 1)
	//GShortA = ShortFileM[0, i-1]+"A"	
	//i=strsearch(LoadFileM, "I", Inf, 1)
	//GLoadA = LoadFileM[0, i-1]+"A"
	//LoadR = LoadFileM[0, i-1]+"RN"
	//Wave LLoadR=$LoadR
	//Make/O/N=(NFreqPnts, NTempPnts)/C $GLoadA
	//SetScale/P y Lowertemp, TempDelta, "", $GLoadA
	//SetScale/P x FreqMin, FreqDelta,"", $GLoadA
	//Wave/C LoadA=$GLoadA
	
	Make/O/C/N=1601 LoadI, LoadA, LoadC, OpenA, OpenI, OPenC
      
	 m=0
	 Do
	    LoadI[m] = conj(1/cmplx(1/LoadR, -1/LoadR*FacLoad/(NFreqPnts-1)*m)) + conj(1/cmplx(1/ContR, -1/ContR*FacCont/(NFreqPnts-1)*m))
	    OpenI[m]= conj(1/cmplx(1E-19, -1*0/LoadR*FacLoad/(NFreqPnts-1)*m)) + conj(1/cmplx(1/ContR, -1/ContR*FacCont/(NFreqPnts-1)*m))
	    m=m+1
       while(m<NFreqPnts)
       
       LoadA = (LoadI-Z0)/(LoadI+Z0)
      OpenA = (OpenI-Z0)/(OpenI+Z0)
       LoadC = conj(1/LoadI)
        OPenC = conj(1/OpenI)

        //Variable/C LoadA 
	//    ZL = (LoadR-Z0)/(LoadR+Z0)
	 //   LoadA = cmplx(ZL, 0)
	
	Newdatafolder/O/S root:ErrorTerms
	SetDataFolder root:ErrorTerms
	
	string ErrorS, ErrorD, ErrorR
	ErrorS="ES_DataSet_"+NDataSet
	ErrorD="ED_DataSet_"+NDataSet
	ErrorR="ER_DataSet_"+NDataSet
	Make/O/N=(NFreqPnts, NTempPnts)/C/D $ErrorS, $ErrorD, $ErrorR
	SetScale/P y Lowertemp, TempDelta, "", $ErrorS, $ErrorD, $ErrorR
	SetScale/P x FreqMin, FreqDelta,"", $ErrorS, $ErrorD, $ErrorR

	Wave/C LErrorS=$ErrorS, LErrorD=$ErrorD, LErrorR=$ErrorR
	string InfoNote=OpenFileM+", "+ShortFileM+", "+LoadFileM
	Note $ErrorS, InfoNote
	Note $ErrorD, InfoNote
	Note $ErrorR, InfoNote
	
	m=0
	Do
			ComDen = OpenM[m]*OpenA[m]*LoadA[m]-OpenA[m]*OpenM[m]*ShortA[m]-OpenA[m]*LoadM[m]*LoadA[m]
			ComDen += -ShortM[m]*ShortA[m]*LoadA[m]+ShortA[m]*LoadM[m]*LoadA[m]+OpenA[m]*ShortA[m]*ShortM[m]
			//print/D ComDen

		
			LErrorS[m] = ShortA[m]*LoadM[m]-LoadM[m]*OpenA[m]+OpenM[m]*LoadA[m]
			LErrorS[m] += -ShortM[m]*LoadA[m]-OpenM[m]*ShortA[m]+OpenA[m]*ShortM[m]
			LErrorS[m] /=ComDen
			//Print/D LErrorS[m]
		
			LErrorD[m] = -OpenA[m]*OpenM[m]*ShortM[m]*LoadA[m]+OpenA[m]*OpenM[m]*ShortA[m]*LoadM[m]+OpenA[m]*LoadM[m]*ShortM[m]*LoadA[m]
			LErrorD[m] += OpenM[m]*LoadA[m]*ShortA[m]*ShortM[m]-OpenM[m]*LoadA[m]*ShortA[m]*LoadM[m]-OpenA[m]*LoadM[m]*ShortA[m]*ShortM[m]
			LErrorD[m] /= -ComDen
			//Print/D LErrorD[m]
		
			LErrorR[m] = (OpenA[m]^2) *(OpenM[m]^2)*ShortM[m]*ShortA[m]-LoadM[m]*(ShortM[m]^2)*(ShortA[m]^2)*OpenA[m]-LoadM[m]*(OpenM[m]^2)*(OpenA[m]^2)*ShortA[m]
			LErrorR[m] += -(OpenA[m]^2)*OpenM[m]*(ShortM[m]^2)*ShortA[m]-(OpenM[m]^2)*(ShortA[m]^2)*ShortM[m]*OpenA[m]+OpenM[m]*(ShortA[m]^2)*(ShortM[m]^2)*OpenA[m]
			LErrorR[m] += -(OpenA[m]^2)*(LoadM[m]^2)*ShortA[m]*ShortM[m]+(OpenA[m]^2)*LoadM[m]*ShortA[m]*(ShortM[m]^2)-LoadM[m]*(LoadA[m]^2)*(ShortM[m]^2)*ShortA[m]
			LErrorR[m] += -(LoadM[m]^2)*(LoadA[m]^2)*OpenM[m]*ShortA[m]-(LoadM[m]^2)*(LoadA[m]^2)*ShortM[m]*OpenA[m]+(LoadM[m]^2)*(LoadA[m]^2)*ShortM[m]*ShortA[m]
			LErrorR[m] += -LoadM[m]*(LoadA[m]^2)*(OpenM[m]^2)*OpenA[m]+(LoadM[m]^2)*(LoadA[m]^2)*OpenM[m]*OpenA[m]-(OpenA[m]^2)*(OpenM[m]^2)*ShortM[m]*LoadA[m]
			LErrorR[m] += -OpenM[m]*LoadA[m]*(ShortA[m]^2)*(ShortM[m]^2)-ShortM[m]*(ShortA[m]^2)*LoadA[m]*(LoadM[m]^2)-OpenM[m]*(OpenA[m]^2)*LoadA[m]*(LoadM[m]^2)
			LErrorR[m] += LoadM[m]*(ShortM[m]^2)*(ShortA[m]^2)*LoadA[m]+LoadM[m]*(OpenM[m]^2)*(OpenA[m]^2)*LoadA[m]-(OpenM[m]^2)*LoadA[m]*(ShortA[m]^2)*LoadM[m]
			LErrorR[m] += OpenA[m]*(OpenM[m]^2)*ShortM[m]*(LoadA[m]^2)-OpenA[m]*OpenM[m]*(ShortM[m]^2)*(LoadA[m]^2)+(OpenA[m]^2)*OpenM[m]*(ShortM[m]^2)*LoadA[m]
			LErrorR[m] += -OpenA[m]*OpenM[m]*(ShortA[m]^2)*(LoadM[m]^2)+(OpenA[m]^2)*OpenM[m]*ShortA[m]*(LoadM[m]^2)+OpenA[m]*(OpenM[m]^2)*(ShortA[m]^2)*LoadM[m]
			LErrorR[m] += (OpenA[m]^2)*(LoadM[m]^2)*ShortM[m]*LoadA[m]+OpenA[m]*LoadM[m]*(ShortM[m]^2)*(LoadA[m]^2)-(OpenA[m]^2)*LoadM[m]*(ShortM[m]^2)*LoadA[m]
			LErrorR[m] += -(OpenM[m]^2)*(LoadA[m]^2)*ShortA[m]*ShortM[m]+OpenM[m]*(LoadA[m]^2)*ShortA[m]*(ShortM[m]^2)+(OpenM[m]^2)*LoadA[m]*(ShortA[m]^2)*ShortM[m]
			LErrorR[m] += OpenM[m]*LoadA[m]*(ShortA[m]^2)*(LoadM[m]^2)+(OpenM[m]^2)*(LoadA[m]^2)*ShortA[m]*LoadM[m]+OpenA[m]*(LoadM[m]^2)*(ShortA[m]^2)*ShortM[m]
			LErrorR[m] /= ComDen
			LErrorR[m] /= ComDen

				
			
		m=m+1
		
	While(m<NFreqPnts)
	
	Killwaves ShortA, Zs
	
End




Function CalculateErrTermsN()
string NDataSet="1"
	prompt NDataSet, "Data Set Number:"
	DoPrompt "Please input the number of the error terms set", NDataSet

	Variable i, j, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta
	String OpenFileM, ShortFileM, LoadFileM, TempFile, LoadR

	SetDataFolder Root:Calibrations

	Prompt OpenFileM, "Choose the file for open standard:", popup, Wavelist("*Int*",";","DIMS:2")
	Prompt ShortFileM, "Choose the file for short standard:", popup, Wavelist("*Int*",";","DIMS:2")
	Prompt LoadFileM, "Choose the file for load standard:", popup, Wavelist("*Int*",";","DIMS:2")
	Doprompt "Choose the interpolated files for calibration standards", OpenFileM, ShortFileM, LoadFileM
	Wave/C OpenM=$OpenFileM, ShortM=$ShortFileM, LoadM=$LoadFileM

	NTempPnts = DimSize($OpenFileM, 1)
	LowerTemp = Dimoffset($OpenFileM, 1)
	TempDelta =DimDelta($OpenFileM, 1)
	NFreqPnts = DimSize($OpenFileM, 0)
	FreqMin = Dimoffset($OpenFileM, 0)
	FreqDelta = DimDelta($OpenFileM, 0)

	Variable  Z0=50, ZL
	Variable/C OpenA=cmplx(1.0, 0), ShortA =cmplx(-1.0, 0), ComDen
	String GLoadA, GShortA

	i=strsearch(ShortFileM, "I", Inf, 1)
	GShortA = ShortFileM[0, i-1]+"A"
	i=strsearch(LoadFileM, "I", Inf, 1)
	GLoadA = LoadFileM[0, i-1]+"A"
	LoadR = LoadFileM[0, i-1]+"RN"
	Wave LLoadR=$LoadR
	Make/O/N=(NFreqPnts, NTempPnts)/C $GLoadA
	SetScale/P y Lowertemp, TempDelta, "", $GLoadA
	SetScale/P x FreqMin, FreqDelta,"", $GLoadA
	Wave/C LoadA=$GLoadA
	j=0
	Do
		ZL = (LLoadR[j]-Z0)/(LLoadR[j]+Z0)
		LoadA[][j] = cmplx(ZL, 0)
		j+=1
	While(j<NTempPnts)

	Newdatafolder/O/S root:ErrorTerms
	SetDataFolder root:ErrorTerms

	string ErrorS, ErrorD, ErrorR
	ErrorS="ES_DataSet_"+NDataSet
	ErrorD="ED_DataSet_"+NDataSet
	ErrorR="ER_DataSet_"+NDataSet
	Make/O/N=(NFreqPnts, NTempPnts)/C/D $ErrorS, $ErrorD, $ErrorR
	SetScale/P y Lowertemp, TempDelta, "", $ErrorS, $ErrorD, $ErrorR
	SetScale/P x FreqMin, FreqDelta,"", $ErrorS, $ErrorD, $ErrorR

	Wave/C LErrorS=$ErrorS, LErrorD=$ErrorD, LErrorR=$ErrorR
	string InfoNote=OpenFileM+", "+ShortFileM+", "+LoadFileM
	Note $ErrorS, InfoNote
	Note $ErrorD, InfoNote
	Note $ErrorR, InfoNote

	m=0
	Do
		k=0
		Do

			ComDen = OpenM[m][k]*OPenA*LoadA[m][k]-OpenA*OpenM[m][k]*ShortA-OpenA*LoadM[m][k]*LoadA[m][k]
			ComDen += -ShortM[m][k]*ShortA*LoadA[m][k]+ShortA*LoadM[m][k]*LoadA[m][k]+OpenA*ShortA*ShortM[m][k]
			//print/D ComDen


			LErrorS[m][k] = ShortA*LoadM[m][k]-LoadM[m][k]*OpenA+OpenM[m][k]*LoadA[m][k]
			LErrorS[m][k] += -ShortM[m][k]*LoadA[m][k]-OpenM[m][k]*ShortA+OpenA*ShortM[m][k]
			LErrorS[m][k] /=ComDen
			//Print/D LErrorS[m][k]

			LErrorD[m][k] = -OpenA*OpenM[m][k]*ShortM[m][k]*LoadA[m][k]+OpenA*OpenM[m][k]*ShortA*LoadM[m][k]+OpenA*LoadM[m][k]*ShortM[m][k]*LoadA[m][k]
			LErrorD[m][k] += OpenM[m][k]*LoadA[m][k]*ShortA*ShortM[m][k]-OpenM[m][k]*LoadA[m][k]*ShortA*LoadM[m][k]-OpenA*LoadM[m][k]*ShortA*ShortM[m][k]
			LErrorD[m][k] /= -ComDen
			//Print/D LErrorD[m][k]

			LErrorR[m][k] = (OpenA^2) *(OpenM[m][k]^2)*ShortM[m][k]*ShortA-LoadM[m][k]*(ShortM[m][k]^2)*(ShortA^2)*OpenA-LoadM[m][k]*(OpenM[m][k]^2)*(OpenA^2)*ShortA
			LErrorR[m][k] += -(OpenA^2)*OpenM[m][k]*(ShortM[m][k]^2)*ShortA-(OpenM[m][k]^2)*(ShortA^2)*ShortM[m][k]*OpenA+OpenM[m][k]*(ShortA^2)*(ShortM[m][k]^2)*OpenA
			LErrorR[m][k] += -(OpenA^2)*(LoadM[m][k]^2)*ShortA*ShortM[m][k]+(OpenA^2)*LoadM[m][k]*ShortA*(ShortM[m][k]^2)-LoadM[m][k]*(LoadA[m][k]^2)*(ShortM[m][k]^2)*ShortA
			LErrorR[m][k] += -(LoadM[m][k]^2)*(LoadA[m][k]^2)*OpenM[m][k]*ShortA-(LoadM[m][k]^2)*(LoadA[m][k]^2)*ShortM[m][k]*OpenA+(LoadM[m][k]^2)*(LoadA[m][k]^2)*ShortM[m][k]*ShortA
			LErrorR[m][k] += -LoadM[m][k]*(LoadA[m][k]^2)*(OpenM[m][k]^2)*OpenA+(LoadM[m][k]^2)*(LoadA[m][k]^2)*OpenM[m][k]*OpenA-(OpenA^2)*(OpenM[m][k]^2)*ShortM[m][k]*LoadA[m][k]
			LErrorR[m][k] += -OpenM[m][k]*LoadA[m][k]*(ShortA^2)*(ShortM[m][k]^2)-ShortM[m][k]*(ShortA^2)*LoadA[m][k]*(LoadM[m][k]^2)-OpenM[m][k]*(OpenA^2)*LoadA[m][k]*(LoadM[m][k]^2)
			LErrorR[m][k] += LoadM[m][k]*(ShortM[m][k]^2)*(ShortA^2)*LoadA[m][k]+LoadM[m][k]*(OpenM[m][k]^2)*(OpenA^2)*LoadA[m][k]-(OpenM[m][k]^2)*LoadA[m][k]*(ShortA^2)*LoadM[m][k]
			LErrorR[m][k] += OpenA*(OpenM[m][k]^2)*ShortM[m][k]*(LoadA[m][k]^2)-OpenA*OpenM[m][k]*(ShortM[m][k]^2)*(LoadA[m][k]^2)+(OpenA^2)*OpenM[m][k]*(ShortM[m][k]^2)*LoadA[m][k]
			LErrorR[m][k] += -OpenA*OpenM[m][k]*(ShortA^2)*(LoadM[m][k]^2)+(OpenA^2)*OpenM[m][k]*ShortA*(LoadM[m][k]^2)+OpenA*(OpenM[m][k]^2)*(ShortA^2)*LoadM[m][k]
			LErrorR[m][k] += (OpenA^2)*(LoadM[m][k]^2)*ShortM[m][k]*LoadA[m][k]+OpenA*LoadM[m][k]*(ShortM[m][k]^2)*(LoadA[m][k]^2)-(OpenA^2)*LoadM[m][k]*(ShortM[m][k]^2)*LoadA[m][k]
			LErrorR[m][k] += -(OpenM[m][k]^2)*(LoadA[m][k]^2)*ShortA*ShortM[m][k]+OpenM[m][k]*(LoadA[m][k]^2)*ShortA*(ShortM[m][k]^2)+(OpenM[m][k]^2)*LoadA[m][k]*(ShortA^2)*ShortM[m][k]
			LErrorR[m][k] += OpenM[m][k]*LoadA[m][k]*(ShortA^2)*(LoadM[m][k]^2)+(OpenM[m][k]^2)*(LoadA[m][k]^2)*ShortA*LoadM[m][k]+OpenA*(LoadM[m][k]^2)*(ShortA^2)*ShortM[m][k]
			LErrorR[m][k] /= ComDen
			LErrorR[m][k] /= ComDen
			k=k+1
		While(k<NTempPnts)

		m=m+1

	While(m<NFreqPnts)

End



Function CaliErrSi()

End

Function CalSampleA()
String  SampleFile, ErrorS, ErrorD, ErrorR, GSampleA, GImpedanceA, GConductivityA
	variable i, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta, Z0=50, g=5.281
	
	SetDataFolder Root:Calibrations
	Prompt SampleFile, "Choose the file for the sample:", popup, Wavelist("*Int*",";","DIMS:2")
	DoPrompt "Choose the interpolated file for the sample", SampleFile
	Wave/C SampleM=$SampleFile
	i = strsearch(SampleFile,"T",inf, 1)
	GSampleA= SampleFile[0, i-1]+"S22A"
	GImpedanceA=SampleFile[0, i-1]+"ImpedanceA"
	GConductivityA=SampleFile[0, i-1]+"ConductivityA"
	NTempPnts = DimSize($SampleFile, 1)
	LowerTemp = Dimoffset($SampleFile, 1)
	TempDelta =DimDelta($SampleFile, 1)
	NFreqPnts = DimSize($SampleFile, 0)
	FreqMin = Dimoffset($SampleFile, 0)
	FreqDelta = DimDelta($SampleFile, 0)

	SetDataFolder Root:ErrorTerms
	Prompt ErrorS, "Choose the file for ES:", popup, Wavelist("ES*",";","DIMS:2")
	Prompt ErrorD, "Choose the file for ED:", popup, Wavelist("ED*",";","DIMS:2")
	Prompt ErrorR, "Choose the file for ER:", popup, Wavelist("ER*",";","DIMS:2")
	Doprompt "Choose the interpolated files for calibration standards", ErrorS, ErrorD, ErrorR
	Wave/C ES=$ErrorS, ED=$ErrorD, ER=$ErrorR

      NewDataFolder/O/S root:SampleActual 
	SetDataFolder root:SampleActual

	Make/O/N=(NFreqPnts, NTempPnts)/C $GSampleA, $GImpedanceA, $GConductivityA
	SetScale/P y Lowertemp, TempDelta, "", $GSampleA, $GImpedanceA, $GConductivityA
	SetScale/P x FreqMin, FreqDelta,"", $GSampleA, $GImpedanceA, $GConductivityA
	Wave/C SampleA=$GSampleA, ImpedanceA=$GImpedanceA, ConductivityA=$GConductivityA

	m=0
	Do
		k=0
		Do
			SampleA[m][k] = (SampleM[m][k]-ED[m][k])/(ER[m][k]+ES[m][k]*(SampleM[m][k]-ED[m][k]))
			ImpedanceA[m][k]= g*Z0*(1+SampleA[m][k])/(1-SampleA[m][k])
			conductivityA[m][k] = conj (1/ImpedanceA[m][k])
			k=k+1
		While(k<NTempPnts)
		
		m=m+1
		
	While(m<NFreqPnts)

	Variable SumSA=0.0
	string InfoNote=ErrorS+", "+ErrorD+", "+ErrorR
	Note $GSampleA, InfoNote
	Note $GImpedanceA, InfoNote

End



Function CalStiff()
	String  ConductivityFile, GStiffness, FrequencyFile
	variable i, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta, scalefactor=ln(2.3/0.7)/2/pi
	
	Prompt ConductivityFile, "Choose the conductivity file for the sample:", popup, Wavelist("*Cond*",";","DIMS:2")
	Prompt FrequencyFile, "Choose the frequency file:", popup, wavelist("*Frequency*",";","DIMS:1")
	DoPrompt "Choose the interpolated file for the sample", ConductivityFile, FrequencyFile
	Wave/C Conductivity=$ConductivityFile
	Wave Frequency=$FrequencyFile
	i = strsearch(ConductivityFile,"C",inf, 1)
	GStiffness= ConductivityFile[0, i-1]+"Stiffness"
	i = strsearch(ConductivityFile,"r",inf, 1)
	GStiffness=GStiffness + ConductivityFile[i+1, inf]
	NTempPnts = DimSize($ConductivityFile, 1)
	LowerTemp = Dimoffset($ConductivityFile, 1)
	TempDelta =DimDelta($ConductivityFile, 1)
	NFreqPnts = DimSize($ConductivityFile, 0)
	FreqMin = Dimoffset($ConductivityFile, 0)
	FreqDelta = DimDelta($ConductivityFile, 0)


	Make/O/N=(NFreqPnts,NTempPnts) $GStiffness, condimag
	Wave/C Stiffness=$GStiffness
	SetScale/P y Lowertemp, TempDelta, "", $GStiffness
	SetScale/P x FreqMin, FreqDelta,"", $GStiffness
	condimag=imag(Conductivity)
      //the coefficient is (6.62607004E-34)^2/(1.38064852E-23)/4/(1.60217662*1E-19)^2
	m=0
	Do
		k=0
		Do
			Stiffness[m][k]= 3.09704946 * 10^(-7)*Frequency[m]*condimag[m][k]
			
			k=k+1
		While(k<NTempPnts)
		
		m=m+1
		
	While(m<NFreqPnts)

End

Function Stiffsingle()


	String  ImPart, FrequencyFile, Gstiffness 
	variable i, m, NFreqPnts, FreqMin, FreqDelta, scalefactor=ln(2.3/0.7)/2/pi
	
	Prompt ImPart, "Choose the imag part for conductivity:", popup, Wavelist("**",";","DIMS:1")
	Prompt FrequencyFile, "Choose the frequency file:", popup, wavelist("*F*",";","DIMS:1")
	DoPrompt "Choose the interpolated file for the sample", ImPart, FrequencyFile
	
	Wave/C ImP=$ImPart
	Wave Frequency=$FrequencyFile
	
	
	GStiffness= "S_" + ImPart 

	NFreqPnts = DimSize($ImPart, 0)
	FreqMin = Dimoffset($ImPart, 0)
	FreqDelta = DimDelta($ImPart, 0)


	Make/O/N=(NFreqPnts) $GStiffness
	Wave/C Stiffness=$GStiffness
	SetScale/P x FreqMin, FreqDelta,"", $GStiffness
	
	m=0
	Do
			
		Stiffness[m]= 3.09704417 *10^(-7)*Frequency[m]*Imp[m]
					
		m=m+1
		
	While(m<NFreqPnts)
	
	
End




Function Move2Cal() //Duplicate S11 or anything to CALIBRATIONS
       String Source
       String  NameC
	Prompt Source, "Choose the Temp file for duplication:", popup, WaveList("*S11*",";","")	
	Doprompt "File selection",  Source
	
	Prompt NameC, "Input the name of copied wave:"	
	Doprompt "Name of copied wave",  NameC
	
	Wave/C Sourcewave=$Source
	
	String currentdatafolder = Getdatafolder (1)
       Newdatafolder/O/S root:CALIBRATIONS
       String destination = Getdatafolder (1)
       Setdatafolder currentdatafolder
       Movewave Sourcewave, $destination
       Rename  Sourcewave, $NameC
        
End

Function DuplicateTandF()
	
       String SourceT, SourceF
	Prompt SourceT, "Choose the Temp file for duplication:", popup, WaveList("*Sample*",";","")	
	Doprompt "File selection",  SourceT	
	Prompt SourceF, "Choose the Freq file for duplication:", popup, WaveList("*Freq*",";","")	
	Doprompt "File selection",  SourceF
	
	Wave/C SourcewaveT=$SourceT
	Wave/C SourcewaveF=$SourceF
	
	Duplicate SourcewaveT, Sample 
	Duplicate SourcewaveF, Frequency
	 
	String currentdatafolder = Getdatafolder (1)
       Newdatafolder/O/S root:SampleActual
       String destination = Getdatafolder (1)
       Setdatafolder currentdatafolder
       Movewave SourcewaveT, $destination
       Movewave SourcewaveF, $destination
       Rename SourcewaveT, Temperature
       Rename SourcewaveF, Frequency
       
End


Function CopyWave()

String SourceWave, NewName = "New"
Prompt SourceWave, "Choose the wave for duplication:", popup, WaveList("**",";","")	
Doprompt "Wave selection",  SourceWave
Wave Source1 = $SourceWave 
NewName = nameofwave(Source1) + "_Cp"
Duplicate Source1, $NewName

End



Function RTErrTerms()

      string NDataSet="1"
	prompt NDataSet, "Data Set Number:"
	DoPrompt "Please input the number of the error terms set", NDataSet
	
	Variable i, j, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta
	String OpenFileM, ShortFileM, LoadFileM, TempFile, LoadR
	
	SetDataFolder Root:CALIBRATIONS

	Prompt OpenFileM, "Choose the file for open standard:", popup, Wavelist("*S11*",";","")
	Prompt ShortFileM, "Choose the file for short standard:", popup, Wavelist("*S11*",";","")
	Prompt LoadFileM, "Choose the file for load standard:", popup, Wavelist("*S11*",";","")
	Doprompt "Choose the interpolated files for calibration standards", OpenFileM, ShortFileM, LoadFileM
	Wave/C OpenM=$OpenFileM, ShortM=$ShortFileM, LoadM=$LoadFileM

	NTempPnts = DimSize($OpenFileM, 1)
	//Print NTempPnts
	LowerTemp = Dimoffset($OpenFileM, 1)
	TempDelta =DimDelta($OpenFileM, 1)
	NFreqPnts = DimSize($OpenFileM, 0)
	//Print NFreqPnts
	FreqMin = Dimoffset($OpenFileM, 0)
	//Print FreqMin
	FreqDelta = DimDelta($OpenFileM, 0)

	Variable  Z0=50, ZL
	Variable/C OpenA=cmplx(1.0, 0), ShortA =cmplx(-1.0, 0), ComDen
	String GLoadA, GShortA

	i=strsearch(ShortFileM, "I", Inf, 1)
	GShortA = ShortFileM[0, i-1]+"A"	
	//Print GShortA
	//Print LoadFileM
	i=strsearch(LoadFileM, "I", Inf, 1)
	GLoadA = LoadFileM[0, i-1]+"A"
	//Print GLoadA
	LoadR = LoadFileM[0, i-1]+"RN"
	Wave LLoadR=$LoadR
	//Print NFreqPnts, NTempPnts, Lowertemp, TempDelta, FreqMin, FreqDelta
	Make/O/N=(NFreqPnts, NTempPnts)/C $GLoadA
	SetScale/P y Lowertemp, TempDelta, "", $GLoadA
	SetScale/P x FreqMin, FreqDelta,"", $GLoadA
	Wave/C LoadA=$GLoadA
	//Print LoadA
	j=0
	Do
		ZL = (LLoadR[j]-Z0)/(LLoadR[j]+Z0)
		LoadA[][j] = cmplx(ZL, 0)
		j+=1
	While(j<NTempPnts)
	
	Newdatafolder/O/S root:ErrorTerms
	SetDataFolder root:ErrorTerms
	
	string ErrorS, ErrorD, ErrorR
	ErrorS="ES_DataSet_"+NDataSet
	ErrorD="ED_DataSet_"+NDataSet
	ErrorR="ER_DataSet_"+NDataSet
	Make/O/N=(NFreqPnts, NTempPnts)/C/D $ErrorS, $ErrorD, $ErrorR
	SetScale/P y Lowertemp, TempDelta, "", $ErrorS, $ErrorD, $ErrorR
	SetScale/P x FreqMin, FreqDelta,"", $ErrorS, $ErrorD, $ErrorR

	Wave/C LErrorS=$ErrorS, LErrorD=$ErrorD, LErrorR=$ErrorR
	string InfoNote=OpenFileM+", "+ShortFileM+", "+LoadFileM
	Note $ErrorS, InfoNote
	Note $ErrorD, InfoNote
	Note $ErrorR, InfoNote
	
	m=0
	Do
		k=0
		Do
		
			ComDen = OpenM[m][k]*OPenA*LoadA[m][k]-OpenA*OpenM[m][k]*ShortA-OpenA*LoadM[m][k]*LoadA[m][k]
			ComDen += -ShortM[m][k]*ShortA*LoadA[m][k]+ShortA*LoadM[m][k]*LoadA[m][k]+OpenA*ShortA*ShortM[m][k]
			//print/D ComDen

		
			LErrorS[m][k] = ShortA*LoadM[m][k]-LoadM[m][k]*OpenA+OpenM[m][k]*LoadA[m][k]
			LErrorS[m][k] += -ShortM[m][k]*LoadA[m][k]-OpenM[m][k]*ShortA+OpenA*ShortM[m][k]
			LErrorS[m][k] /=ComDen
			//Print/D LErrorS[m][k]
		
			LErrorD[m][k] = -OpenA*OpenM[m][k]*ShortM[m][k]*LoadA[m][k]+OpenA*OpenM[m][k]*ShortA*LoadM[m][k]+OpenA*LoadM[m][k]*ShortM[m][k]*LoadA[m][k]
			LErrorD[m][k] += OpenM[m][k]*LoadA[m][k]*ShortA*ShortM[m][k]-OpenM[m][k]*LoadA[m][k]*ShortA*LoadM[m][k]-OpenA*LoadM[m][k]*ShortA*ShortM[m][k]
			LErrorD[m][k] /= -ComDen
			//Print/D LErrorD[m][k]
		
			LErrorR[m][k] = (OpenA^2) *(OpenM[m][k]^2)*ShortM[m][k]*ShortA-LoadM[m][k]*(ShortM[m][k]^2)*(ShortA^2)*OpenA-LoadM[m][k]*(OpenM[m][k]^2)*(OpenA^2)*ShortA
			LErrorR[m][k] += -(OpenA^2)*OpenM[m][k]*(ShortM[m][k]^2)*ShortA-(OpenM[m][k]^2)*(ShortA^2)*ShortM[m][k]*OpenA+OpenM[m][k]*(ShortA^2)*(ShortM[m][k]^2)*OpenA
			LErrorR[m][k] += -(OpenA^2)*(LoadM[m][k]^2)*ShortA*ShortM[m][k]+(OpenA^2)*LoadM[m][k]*ShortA*(ShortM[m][k]^2)-LoadM[m][k]*(LoadA[m][k]^2)*(ShortM[m][k]^2)*ShortA
			LErrorR[m][k] += -(LoadM[m][k]^2)*(LoadA[m][k]^2)*OpenM[m][k]*ShortA-(LoadM[m][k]^2)*(LoadA[m][k]^2)*ShortM[m][k]*OpenA+(LoadM[m][k]^2)*(LoadA[m][k]^2)*ShortM[m][k]*ShortA
			LErrorR[m][k] += -LoadM[m][k]*(LoadA[m][k]^2)*(OpenM[m][k]^2)*OpenA+(LoadM[m][k]^2)*(LoadA[m][k]^2)*OpenM[m][k]*OpenA-(OpenA^2)*(OpenM[m][k]^2)*ShortM[m][k]*LoadA[m][k]
			LErrorR[m][k] += -OpenM[m][k]*LoadA[m][k]*(ShortA^2)*(ShortM[m][k]^2)-ShortM[m][k]*(ShortA^2)*LoadA[m][k]*(LoadM[m][k]^2)-OpenM[m][k]*(OpenA^2)*LoadA[m][k]*(LoadM[m][k]^2)
			LErrorR[m][k] += LoadM[m][k]*(ShortM[m][k]^2)*(ShortA^2)*LoadA[m][k]+LoadM[m][k]*(OpenM[m][k]^2)*(OpenA^2)*LoadA[m][k]-(OpenM[m][k]^2)*LoadA[m][k]*(ShortA^2)*LoadM[m][k]
			LErrorR[m][k] += OpenA*(OpenM[m][k]^2)*ShortM[m][k]*(LoadA[m][k]^2)-OpenA*OpenM[m][k]*(ShortM[m][k]^2)*(LoadA[m][k]^2)+(OpenA^2)*OpenM[m][k]*(ShortM[m][k]^2)*LoadA[m][k]
			LErrorR[m][k] += -OpenA*OpenM[m][k]*(ShortA^2)*(LoadM[m][k]^2)+(OpenA^2)*OpenM[m][k]*ShortA*(LoadM[m][k]^2)+OpenA*(OpenM[m][k]^2)*(ShortA^2)*LoadM[m][k]
			LErrorR[m][k] += (OpenA^2)*(LoadM[m][k]^2)*ShortM[m][k]*LoadA[m][k]+OpenA*LoadM[m][k]*(ShortM[m][k]^2)*(LoadA[m][k]^2)-(OpenA^2)*LoadM[m][k]*(ShortM[m][k]^2)*LoadA[m][k]
			LErrorR[m][k] += -(OpenM[m][k]^2)*(LoadA[m][k]^2)*ShortA*ShortM[m][k]+OpenM[m][k]*(LoadA[m][k]^2)*ShortA*(ShortM[m][k]^2)+(OpenM[m][k]^2)*LoadA[m][k]*(ShortA^2)*ShortM[m][k]
			LErrorR[m][k] += OpenM[m][k]*LoadA[m][k]*(ShortA^2)*(LoadM[m][k]^2)+(OpenM[m][k]^2)*(LoadA[m][k]^2)*ShortA*LoadM[m][k]+OpenA*(LoadM[m][k]^2)*(ShortA^2)*ShortM[m][k]
			LErrorR[m][k] /= ComDen
			LErrorR[m][k] /= ComDen		
		
			k=k+1
		While(k<NTempPnts)
		
		m=m+1
		
	While(m<NFreqPnts)
	

End

Function OneTempPnt()  //extract one temp point from a multidimensional wave, the real part only. 

Variable NofF = 1601, n1 =0, n2 =0, i, field = 0
Prompt NofF, "Number of Frequencies:"
DoPrompt "Please input the N of Fs", NofF

String wavefile
Prompt wavefile, "Choose the wanted file:", popup, wavelist("*",";","")
Doprompt "Choose the wanted file", wavefile 
Wave/C wave0 = $wavefile 

Prompt field, "Field"
DoPrompt "Field", field

Prompt n1, "The column number for real:"
DoPrompt "Please input the column number for real", n1
String NofWaveR = "R" + num2str(n1) + "_" + num2str(field) + "T"	
Prompt NofWaveR, "Name of wave:"
DoPrompt "Please input the name of  new wave for real", NofWaveR

Prompt n2, "The column number for imag:"
DoPrompt "The number of column for imag that is to be turned real",  n2
String NofWaveI = "I" +  num2str(n2) + "_" + num2str(field) + "T"
Prompt NofWaveI, "Name of wave:"
  DoPrompt "Please input the name of  new wave for imag", NofWaveI
  
   
Make/O/N=(NofF) RPart
Make/O/N=(NofF) IPart

RPart = real(wave0[p][n1])
for(i=0; i<=NofF;i=i+1)	
		IPart[i]=imag(wave0[i][n2])									
	endfor	
	
String Answer="no"
Variable Thickness = 20, Factor = 1E7, geo =2*Pi/ln(2.3/0.7)
	Prompt  Answer, "Want to convert the unit?", popup "yes;no"
	Doprompt "Unit conversion for thin films?", Answer
	If (cmpstr(Answer, "yes") == 0)
	   Prompt Thickness, "What is the thickness of your film (in nm)?"
         DoPrompt "The thickness in nm",  Thickness
         Prompt Factor, "Please mannually insert another constant factor"
         DoPrompt "The constant factor",  Factor
         RPart = Factor*RPart/Thickness/geo
         IPart = Factor*IPart/Thickness/geo
      Endif
      
      
Make/C/O/N=(NofF) CplxWave = cmplx (RPart, IPart) 
String CpxWName = "Cplx" + num2str(n1) + "_" + num2str(field) + "T"				
		
Rename RPart, $NofWaveR
Rename IPart, $NofWaveI
Rename CplxWave, $CpxWName

End

//This function combines two real waves into a complex wave. 
Function CombineCX()
Variable NofF = 1601, n1 =1, n2 =0, i
Prompt NofF, "Number of Frequencies:"
DoPrompt "Please input the N of Fs", NofF

String wave1, wave2
Prompt wave1, "Choose wave 1:", popup, wavelist("*",";","")
Prompt wave2, "Choose wave 1:", popup, wavelist("*",";","")
Doprompt "Choose the wanted file", wave1, wave2
Wave wv1 = $wave1
Wave wv2 = $wave2
          
Make/C/O/N=(NofF) CplxWave = cmplx (wv1, wv2) 
String Newname 	
Prompt  Newname, "Enter disired name for the complex wave:"
Doprompt "New name for the created complex wave",  Newname
Rename CplxWave $Newname 					
Killwaves wv1, wv2 
End


Function ImagPart()  //get the imaginary part of a certain wave 

End 

Function VtoR()

String Vwave, NameofR = "SampleR", NameofRS = "SampleRS"

Variable NofP=10, multiplier = 1e7, g = 2*pi/ln(2.3/0.7), Voltage = 0.3

Prompt Vwave, "Choose the voltage file:", popup, Wavelist("*voltage*",";","")
Doprompt "Choose the V file to be converted to R file", Vwave

Wave V_wave = $Vwave

Prompt  multiplier, "Enter the resistance in series:"
Doprompt "Input the multiplier based on current",  multiplier

Prompt  Voltage, "Enter the applied voltage:"
Doprompt "Reference Voltage",  Voltage

NofP = dimsize(V_wave, 0)

Make/O/N= (NofP) Rwave
Make/O/N= (NofP) RSwave

Rwave = multiplier*V_wave/(Voltage-V_wave)
RSwave = g*Rwave

Variable AvgR=0, i=0
for(i=0; i<NofP;i=i+1)	
		AvgR+=RSwave[i]						
	endfor	
AvgR =AvgR/NofP
Print AvgR
Prompt   NameofR, "Enter the new name"
Doprompt "Name of the resistance wave",  NameofR
 
NameofRS  = NameofR +"_SheetR"
NameofR= NameofR + "_Resistance" 

Rename Rwave $NameofR
Rename RSwave $NameofRS

End


Function Con2Mag()   //Get the real part of S22 wave // This function was later editted to generate the phase of S22 at the same time

String S22wave, NofWave = "", NofWave1 = ""

Prompt S22wave, "Choose the Real wave:", popup, Wavelist("**",";","")
Doprompt "Choose the V file to be converted to R file", S22wave

Wave S22_wave = $S22wave

Variable LofWave=1601
LofWave = dimsize(S22_wave, 0)

Prompt  NofWave , "Enter the name of the new wave:"
Doprompt "Name for the new wave",  NofWave 

Make/O/N= (LofWave) NewWave1
Make/O/N= (LofWave) NewWave2

NewWave1 =  Real(r2polar(S22_wave))
NewWave2 = Imag(r2polar(S22_wave))

NofWave1= NofWave + "_MagS22" 
NofWave = NofWave +"_ImagS22"

	String currentdatafolder = Getdatafolder (1)
       Newdatafolder/O/S root:S22s
       String destination = Getdatafolder (1) 
       Setdatafolder currentdatafolder
       Movewave NewWave1, $destination
        Setdatafolder currentdatafolder
       Movewave NewWave2, $destination
       Rename NewWave1 $NofWave1
       Rename NewWave2 $NofWave
Killwaves S22_wave

End


//Below are some specific functions that you might want to use for your calculations

Function ExtDrude()
       Variable omega_p = 1000   //Plasma freq
	 prompt  omega_p, "Plasma freq:"
	 DoPrompt "Please enter the plasma freq in THz", omega_p
       String ConR, ConI, Freq
	Prompt ConR, "Choose the conductivity file, real part:", popup, WaveList("**",";","")	
	Doprompt "File selection",  ConR	
	Prompt ConI, "Choose the conductivity file, imag part:", popup, WaveList("**",";","")	
	Doprompt "File selection",  ConI
	Prompt Freq, "Choose the freq file:", popup, WaveList("**",";","")	
	Doprompt "File selection",  Freq
	
	Wave ReCon=$ConR, ImCon =$ConI, Frequency = $Freq
		
	  Variable NofP  = 86	
        Prompt  NofP, "# of freq points:"
	 DoPrompt "Please enter the # of freq pts", NofP
	
	Make/N=(NofP) srate, lambda
	//srate = (omega_p)^2/4/Pi * ( ReCon) / ( ReCon^2 + ImCon^2)
	//lambda = (omega_p)^2/4/Pi *ImCon/(ReCon^2 +  ImCon^2)/Frequency
	//Note that in the formula below /2/pi is due to using f instead of omega in the frequencies . Also sigma is in terms of ohm-1 cm-1 instead of ohm-1 m-1 so the result needs to be divided by 100
	
	srate = (omega_p)^2*8.85/2/Pi * ( ReCon) / ( ReCon^2 + ImCon^2)/100
	lambda = (omega_p)^2*8.85/2/Pi *ImCon/(ReCon^2 +  ImCon^2)/Frequency/100
	
	
	 String name_srate ="sample", name_Lambda ="sample"
	Prompt  name_srate, "New name for scattering rate:"
	 DoPrompt "Please enter the new name for tau", name_srate
	 
	 name_srate = name_srate + "_srate"
	 
	 Rename srate, $name_srate
	 
	  Prompt  name_Lambda, "New name for scattering rate:"
	 DoPrompt "Please enter the new name for tau", name_Lambda
	 
	  name_Lambda = name_Lambda + "_mass"
	 
	 Rename lambda, $name_Lambda
		
End 

// Combine two real waves that are under the same folder and then save them as a .dat file 
Function SV2WVS()

      String XAxis, YAxis
      
	Prompt XAxis, "Choose the X-Coordinate file, e.g, freqeuncy:", popup, WaveList("*F*",";","")	
	Prompt YAxis, "Choose the Y-Coordinate file, e.g. conductivity:", popup, WaveList("**",";","")	
	Doprompt "File selection",  XAxis, YAxis
	
	String Ans = "yes"	
	Variable Length = 639, i =0 
	Prompt  Ans, "Trim waves?", popup "yes;no"
	Doprompt "Trim waves?", Ans	
	If (cmpstr(Ans, "yes") == 0)
	 Prompt  Length, "Length of trimmed waves:"
	 DoPrompt "Please enter length of trimmed waves:", Length
	 Make/O/N=(Length) TempX, TempY
	 Wave XA = $XAxis, YA = $YAxis 
	for(i=0;i<Length;i=i+1)
	TempX[i] = XA[i]
	TempY[i] = YA[i] 
	endfor 
	Save/E=0/I/J/M="\r\n" TempX, TempY
	Killwaves TempX, TempY	
	else 
	Save/E=0/I/J/M="\r\n" $XAxis, $YAxis
	endif 
End 
	
//Save a complex wave of 1D 	
Function  SV2CX()

      String CXwave
	Prompt  CXwave, "Choose the complex wave you wish to save:", popup, WaveList("**",";","")	
	Doprompt "File selection",  CXwave
	Save/I/J $CXwave
	
End 	
	
	
//Convert the frequency to wave#	
Function F2WNo() 
       String Freq
       Variable multiplier = 1
	Prompt Freq, "Choose the freqeuncy file", popup, WaveList("*F*",";","")	
	Doprompt "File selection",  Freq
	Wave Frequency = $Freq
	Frequency = Frequency* (1E-12) * 33.35641
      Prompt  multiplier, "Now freq has been converted to wavenumber, any other multiplier?"
      Doprompt "Input the multiplier based on current",  multiplier
      Frequency = Frequency *multiplier
      Make/O/N=1601 NewFrequency 
      NewFrequency = Frequency
      Killwaves Frequency   

End


Function Avg_T()  //extract one temperature point, but it is an average of adjacent five points  

Variable NofF = 1601, n1 =1, n2 =0, i, j, k, Navg = 5, field = 0
Prompt NofF, "Number of Frequencies:"
DoPrompt "Please input the N of Fs", NofF

String wavefile
Prompt wavefile, "Choose the wanted file:", popup, wavelist("*",";","")
Doprompt "Choose the wanted file", wavefile 
Wave wave0 = $wavefile 

Prompt field, "The magnetic field:"
DoPrompt "Please input the magnetic field", field

Prompt n1, "The column number for real:"
DoPrompt "Please input the column number for real", n1
String NofWave  = "R_" + num2str(n1) +"_" + num2str(field) + "T"
Prompt NofWave, "Name of wave:"
DoPrompt "Please input the name of  new wave for real", NofWave

Prompt n2, "The column number for imag:"
DoPrompt "The number of column for imag that is to be turned real",  n2
String NofWave2 = "I_" + num2str(n2) +"_" + num2str(field) + "T"
Prompt NofWave2, "Name of wave:"
  DoPrompt "Please input the name of  new wave for imag", NofWave2
  
Prompt Navg, "Number of temperature poins for this average:"
DoPrompt "Please input the # of T points", Navg

Make/O/N=(NofF) RPart = 0
Make/O/N=(NofF) IPart = 0

for(i=0; i<Navg;i=i+1)	
		RPart += wave0[p][n1]
		n1+=1							
	endfor	
RPart = RPart/Navg


for(j=0; j<Navg;j=j+1)	
      
      for(k=0; k<=NofF;k=k+1)	
		IPart[k]+= imag(wave0[k][n2])									
	endfor
	n2+=1
	
endfor
Ipart = Ipart/Navg	

	
String Answer="no"
Variable Thickness = 20, Factor = 1E7, geo =2*Pi/ln(2.3/0.7)
	Prompt  Answer, "Want to convert the unit?", popup "yes;no"
	Doprompt "Unit conversion for thin films?", Answer
	If (cmpstr(Answer, "yes") == 0)
	   Prompt Thickness, "What is the thickness of your film (in nm)?"
         DoPrompt "The thickness in nm",  Thickness
         Prompt Factor, "Please mannually insert another constant factor"
         DoPrompt "The constant factor",  Factor
         RPart = Factor*RPart/Thickness/geo
         IPart = Factor*IPart/Thickness/geo
      Endif

Rename RPart, $NofWave
Rename IPart, $NofWave2

End



Function Avg_F()  //box averaging of data in terms of frequency 

Variable NofF = 1601, i, j=0, k=0, Navg = 16
Prompt NofF, "Number of Frequencies:"
DoPrompt "Please input the N of Fs", NofF
Prompt Navg, "Number of Frequencies:"
DoPrompt "Please input the N of Fs", Navg

String ReWave, ImWave, Freq
Prompt  Freq, "Choose the original frequency file:", popup, wavelist("*",";","")
Doprompt "Original frequencies",  Freq
Prompt ReWave, "Choose the real part:", popup, wavelist("*",";","")
Doprompt "Choose the real part", ReWave
Prompt ImWave, "Choose the real part:", popup, wavelist("*",";","")
Doprompt "Choose the real part", ImWave
Wave Frequency = $Freq 
Wave sigma1 = $ReWave
Wave sigma2 = $ImWave

//Take the average
k=0
Make/O/N = (NofF/Navg) AvgF, AvgS1, AvgS2

      for(i=1; i<=NofF;i+=Navg)
          AvgF[k]=0	
          AvgS1[k]=0
          AvgS2[k]=0
		for (j=0;j<Navg;j+=1)
		AvgF[k]+=Frequency[k*Navg+j]	
		AvgS1[k]+=sigma1[k*Navg+j]		
		AvgS2[k]+=sigma2[k*Navg+j]				
		endfor
		AvgF[k] =AvgF[k]/Navg
		AvgS1[k] =AvgS1[k]/Navg
		AvgS2[k] =AvgS2[k]/Navg
		k+=1		
	endfor
End

Function TempField()
String SampleT, BinKG
Variable Field=0, NofP, AvgT = 0, i=0  //the average of temperatures
String Newname = "Sample"
Prompt SampleT, "Choose the sample temperature:", popup, Wavelist("*Sa*",";","")
Prompt BinKG, "Choose the field file:", popup, Wavelist("*Bin*",";","")
Doprompt "Uncalibrated temperature, magnetic field", SampleT, BinKG
Prompt Field, "The magnetic field:"
DoPrompt "Please input the magnetic field", Field
Wave SampleCal = $SampleT
Wave SampleFld = $BinKG
SampleCal = SampleCal * (1+ 0.009*SampleFld/10)
NofP = dimsize(SampleCal, 0)
Make/O/N= (NofP) SampleTNew = SampleCal
For(i=0; i<NofP;i+=1)
AvgT += SampleTNew[i]
Endfor
AvgT = AvgT/NofP
Print AvgT
Newname = Newname + num2str(Field)
Rename SampleTNew, $Newname
End



Function IntpErrTerms()
SetDataFolder root:ErrorTerms
Variable NofFields=16                   //Number of fields after interpolation 
Prompt NofFields, "Please input the desired number of error term datasets"
Doprompt "The number of error term datasets", NofFields

Variable i, j, k, l, NofTs =100, NofFrequency=1601, NofSets = 2 //Number of fields before interpolation 
Prompt NofTs, "Please input the number of temperatures"
Prompt NofFrequency, "Please input the number of frequencies"
Doprompt "The number of temperatures and frequencies in one dataset", NofTs, NofFrequency 

Variable lowF =0, highF = 7.5
//Variable lowF =0, highF = 0.5

String ErrorS, ErrorD, ErrorR
ErrorS="ES_DataSet_"
ErrorD="ED_DataSet_"
ErrorR="ER_DataSet_"

for(i=0;i<NofFields;i=i+1)
Make/O/C/N=((NofFrequency), (NofTs)) TempES
Make/O/C/N=((NofFrequency), (NofTs)) TempED
Make/O/C/N=((NofFrequency), (NofTs)) TempER
ErrorS="ES_DataSet_N" + num2str(lowF+i*(highF-lowF)/(NofFields-1))
ErrorD="ED_DataSet_N" + num2str(lowF+i*(highF-lowF)/(NofFields-1))
ErrorR="ER_DataSet_N"  + num2str(lowF+i*(highF-lowF)/(NofFields-1))
Rename TempES $ErrorS
Rename TempED $ErrorD
Rename TempER $ErrorR
endfor


//Make/O/D/N=(NofSets) SourceX={0, 0.5, 2, 4, 6, 7.5} //Intial valuse for dataset fields 
Make/O/D/N=(NofSets) SourceX={0, 0.5} //Intial valuse for dataset fields 

//Make/O/C/N=(Nofsets) TempESS //This is a source wave for one temperature point and one frequency point  
//Make/O/C/N=(Nofsets) TempESD
//Make/O/C/N=(Nofsets) TempESR

Make/O/N=(Nofsets) TempESSR //This is a source wave for one temperature point and one frequency point, REAL PART  
Make/O/N=(Nofsets) TempESDR
Make/O/N=(Nofsets) TempESRR

Make/O/N=(Nofsets) TempESSI //This is a source wave for one temperature point and one frequency point, IMAG PART  
Make/O/N=(Nofsets) TempESDI
Make/O/N=(Nofsets) TempESRI



Make/O/N=(NofFields) DestinationX 
//for(i=0;i<NofFields;i++)
//DestinationX[i] =lowF+i*(highF-lowF)/(NofFields-1)
//endfor 
//Make/O/C/N=(NofFields) TempESD //This is a desitnation wave for one temperature point and one frequency point  
//Make/O/C/N=(NofFields) TempEDD
//Make/O/C/N=(NofFields) TempERD

Make/O/N=(NofFields) TempEDSR //This is a desitnation wave for one temperature point and one frequency point, REAL PART  
Make/O/N=(NofFields) TempEDDR
Make/O/N=(NofFields) TempEDRR

Make/O/N=(NofFields) TempEDSI //This is a desitnation wave for one temperature point and one frequency point, IMAG PART  
Make/O/N=(NofFields) TempEDDI
Make/O/N=(NofFields) TempEDRI

String ErrS, ErrD, ErrR //Temparary waves to assign values to source waves. 
ErrS="ES_DataSet_"
ErrD="ED_DataSet_"
ErrR="ER_DataSet_"


    for(i=0;i<NofTs; i=i+1)
        for(j=0;j<NofFrequency;j=j+1)    
            for(k=0;k<NofSets;k=k+1)
           ErrS="ES_DataSet_" + num2str(SourceX[k])
           ErrD="ED_DataSet_" + num2str(SourceX[k])
           ErrR="ER_DataSet_" + num2str(SourceX[k])
           Wave/C  ES = $ErrS
           Wave/C  ED = $ErrD 
           Wave/C  ER = $ErrR 
           //TempESSR[k] = real(ES[j][i])
           //TempESDR[k] = real(ED[j][i])
           //TempESRR[k] = real(ER[j][i])
            //TempESSI[k] = imag(ES[j][i])
           //TempESDI[k] = imag(ED[j][i])
           //TempESRI[k] = imag(ER[j][i])
           
           TempESSR[k] = real(ES[j])
           TempESDR[k] = real(ED[j])
           TempESRR[k] = real(ER[j])
            TempESSI[k] = imag(ES[j])
           TempESDI[k] = imag(ED[j])
           TempESRI[k] = imag(ER[j])
           
           endfor  
           Interpolate2 /T=1/N=(NofFields)/Y=TempEDSR/X=DestinationX SourceX, TempESSR
           Interpolate2 /T=1/N=(NofFields)/Y=TempEDDR/X=DestinationX SourceX, TempESDR
           Interpolate2 /T=1/N=(NofFields)/Y=TempEDRR/X=DestinationX SourceX, TempESRR
           
           Interpolate2 /T=1/N=(NofFields)/Y=TempEDSI/X=DestinationX SourceX, TempESSI
           Interpolate2 /T=1/N=(NofFields)/Y=TempEDDI/X=DestinationX SourceX, TempESDI
           Interpolate2 /T=1/N=(NofFields)/Y=TempEDRI/X=DestinationX SourceX, TempESRI           
           
           for(l=0;l<NofFields;l=l+1)
           ErrorS="ES_DataSet_N" + num2str(lowF+l*(highF-lowF)/(NofFields-1))
           ErrorD="ED_DataSet_N" + num2str(lowF+l*(highF-lowF)/(NofFields-1))
           ErrorR="ER_DataSet_N"  + num2str(lowF+l*(highF-lowF)/(NofFields-1))
           Wave/C ESN = $ErrorS    //local wave declaration                      
           Wave/C EDN= $ErrorD
           Wave/C ERN  =$ErrorR
           //ESN[j][i] =  cmplx(TempEDSR[l], TempEDSI[l])
           //EDN[j][i] =   cmplx(TempEDDR[l], TempEDDI[l])
           //ERN[j][i] =  cmplx(TempEDRR[l], TempEDRI[l])
           
           ESN[j] =  cmplx(TempEDSR[l], TempEDSI[l])
           EDN[j] =   cmplx(TempEDDR[l], TempEDDI[l])
           ERN[j] =  cmplx(TempEDRR[l], TempEDRI[l])
           endfor
    endfor
endfor 

Killwaves TempEDSR,  TempEDDR,  TempEDRR, TempEDSI, TempEDDI, TempEDRI, TempESSR,  TempESDR,  TempESRR, TempESSI,  TempESDI,  TempESRI

End



Function IntRange()

String XWave, YWave
Prompt XWave, "Choose the frequency wave:", popup, Wavelist("*F*",";","")
Prompt YWave, "Choose the Y-wave to be integrated:", popup, Wavelist("**",";","")
Doprompt "The number of error term datasets", XWave, YWave

Wave XW = $XWave
Wave YW = $YWave


Variable Cutoff = 639
Prompt Cutoff, "Please enter the point where you want to cut the data"
DoPrompt "The cutoff frequency", Cutoff

Make/N=(Cutoff +1) TempX
Make/N=(Cutoff)  TempY
Variable i=0
TempX[0] =0
for(i=0;i<Cutoff;i=i+1)
TempX[i+1]= XW[i]
TempY[i]=YW[i]
endfor 

String NewName
NewName = YWave +"N"

Make/N=(Cutoff) DestW

Integrate TempY  /X =TempX /D=DestW
Rename DestW $NewName
KillWaves TempX, TempY

End


Function DupShort()  //This function makes duplicate SC  short reflection coefficiets at base temperature for a given range of temperatures. The file can be used as an interpolated one for calculating error terms. 
       String Shortfile
	Prompt Shortfile, "Choose the SC reflection coeffecient file at base T", popup, Wavelist("**",";","DIMS:1")
	Doprompt "SC Short", Shortfile
	Wave/C BTShort = $Shortfile
	
	Variable NFreq=1601, TPnts = 100
     Prompt NFreq, "Please enter the number of frequencies"
     Prompt TPnts, "Please enter the number of temperatutres points for interpolation"
     Doprompt "Frequencies and temperature points",  NFreq, TPnts      
     Make/O/C/N=(1601,100) Int_SC_Short
          Variable i =0 , j =0
        for(i=0;i<NFreq; i=i+1)
        for(j=0;j<TPnts;j=j+1)    
        Int_SC_Short[i][j] = BTShort[i]        
        endfor
        endfor 
        String currentdatafolder = GetDataFolder(1)	
       NewDataFolder/O/S root:Calibrations
      String destination =  GetDataFolder(1)	
      Setdatafolder currentdatafolder
      MoveWave  Int_SC_Short, $destination
 End
 
 
Function Dep4Plot() // decomposes a 2D complex wave into many 1D waves for the convinience of plotting. Will need to move a frequency wave to this folder 
String currentdatafolder = GetDataFolder(1)	
String Datawave
String Field = "0"
Prompt Datawave, "Choose the file for decomposition:", popup, Wavelist("**",";","DIMS:2")
Prompt Field, "Please enter the magnetic field of this data"
Doprompt "Data wave", Datawave, Field
Wave/C Source=$Datawave

NewDataFolder/O root:G1
NewDataFolder/O root:G2

Variable NTempPnts =100, NofFreqPnts = 1601, LowerTemp =0.38, TempDelta = 0
NTempPnts = DimSize(Source, 1)
NofFreqPnts = DimSize(Source, 0)
LowerTemp = Dimoffset(Source, 1)
TempDelta =DimDelta(Source, 1)

Variable i =0, j =0, Temperature = LowerTemp
String G1Name = "G1", G2Name = "G2"
String destination = GetDataFolder(1)
Make/O/T/N=(NTempPnts) G1NameWave
Make/O/T/N=(NTempPnts) G2NameWave	
for(i=0;i<NTempPnts; i=i+1)
    Setdatafolder currentdatafolder
    Make/O/N=(NofFreqPnts) TempG1
    Make/O/N=(NofFreqPnts) TempG2
    for(j=0;j<NofFreqPnts;j=j+1)    
      TempG1[j] = real(Source[j][i])
      TempG2[j] = imag(Source[j][i])
    endfor
       Temperature = LowerTemp + i*TempDelta
       G1Name = "G1" + "_" + Field +"T" + "_" + num2str(Temperature) + "K"
       G1NameWave[i] =  G1Name
       G2Name = "G2" + "_" + Field +"T" + "_" + num2str(Temperature) + "K"
       G2NameWave[i] =  G2Name
      NewDataFolder/O/S root:G1
      destination =  GetDataFolder(1)	
      Setdatafolder currentdatafolder
      MoveWave  TempG1, $destination
      Rename TempG1  $G1Name
      
      NewDataFolder/O/S root:G2
      destination =  GetDataFolder(1)	
      Setdatafolder currentdatafolder
      MoveWave  TempG2, $destination
      Rename TempG2  $G2Name                   
endfor   

//Setdatafolder root:G1
//PauseUpdate; Silent 1		// building window...
//String fldrSav0= GetDataFolder(1)
//Display /W=(432.75,209.75,882.75,593.75)/N=G1 :root:G1:Frequency vs Frequency
//for(i=1;i<NTempPnts; i=i+1)
//AppendToGraph :root:G1: $G1NameWave[i] vs Frequency 
//endfor 
//SetDataFolder fldrSav0
//ModifyGraph width=324,height={Aspect,0.95}
//ModifyGraph lSize=1
//ModifyGraph log=1
//ModifyGraph mirror=1
//ModifyGraph fSize=18
//ModifyGraph fStyle=1
//ModifyGraph axThick=2
//Label left "\\f01\\Z18 G\\B1\\M\\Z18 (\\F'Symbol'W\\F'Arial'\\S-1\\M\\Z18\\Z18/\\F'Wingdings'o\\F'Arial'\\Z18)"
//Label bottom "\\f01\\Z18 \\F'Symbol'w\\F'Arial'/2\\F'Symbol'p\\F'Arial' (Hz)"
//SetAxis left 0.0003,0.2
//SetAxis bottom 50000000,8000000000
	//string trl=tracenamelist("",";",1), item
	//variable items=itemsinlist(trl)
	//variable ink= 255/(items-1)
	//colortab2wave rainbow256
	//wave/i/u M_colors
	//for(i=0;i<items;i+=1)
		//item=stringfromlist(i,trl)
		//ModifyGraph rgb($item)=(M_colors[255-i*ink][0],M_colors[255-i*ink][1],M_colors[255-i*ink][2])
	//endfor
	//killwaves/z M_colors

 
End
.
Function SVThermal() //this function saves to a 2D wave (usually temperature dependent data) for python fitting. 

      String XWave, ThermalWave
      
	Prompt XWave, "Choose the first column file, e.g, frequency:", popup, WaveList("**",";","")	
	Prompt ThermalWave, "Choose the complex 2D wave:", popup, WaveList("**",";","")	
	Doprompt "File selection",  XWave, ThermalWave

	Variable Length = 639, NofT=200, i =0, j=0 
	 Prompt  Length, "Length of trimmed waves:"
	 DoPrompt "Please enter length of trimmed waves:", Length
	 
	 Wave XA = $XWave
	 Wave/C YA = $ThermalWave
	 NofT = dimsize(YA,1) +1
	 print NofT
	 NofT=NofT*2
	 //Make/O/N=(Length) TempX
	 Make/O/N=(Length,(NofT+1)) TempY
       NofT=NofT/2
       for(i=0;i<Length;i=i+1)
	TempY[i][0] = XA[i]
	endfor 
	for(i=0;i<Length;i=i+1)
	  for(j=0;j<NofT;j=j+1)	
		TempY[i][2*j+1] = real(YA[i][j]) 
	       TempY[i][2*j+2] = imag(YA[i][j]) 
	       endfor
	       endfor 
	Save/E=0/I/J/M="\r\n" TempY
	Killwaves  TempY	       
	//for(i=0;i<Length;i=i+1)
	//TempX[i] = XA[i]
	//endfor 
	//for(i=0;i<Length;i=i+1)
	  //for(j=0;j<NofT;j=j+1)	
		//TempY[i][2*j] = real(YA[i][j]) 
	       //TempY[i][2*j+1] = imag(YA[i][j]) 
	       //endfor
	       //endfor 
	//Save/E=0/I/J/M="\r\n" TempX, TempY
	//Killwaves TempX, TempY	
End 

//2017 Dec

//a new function which takes the data at the same temperature and averages it.
Function LoadOneTemp() 
       String Files, TempFilename, Resistance, NameofSam="IT_"
	Variable NTempPnts=10 
	Prompt Files, "Choose the filenames file:", popup, Wavelist("*Time*",";","DIMS:1")
	Prompt TempFilename, "Choose the temperature file:", popup, Wavelist("*Sample*",";","DIMS:1")
	Prompt Resistance, "Choose the resistance file",popup, Wavelist("*Res*",";","DIMS:1")
	Prompt NTempPnts, "Enter the number of temperature points"
	Prompt NameofSam, "Enter the name of the sample"
	Doprompt "The data to be averaged", Files, TempFilename, Resistance, NTempPnts, NameofSam
 
      	variable NumFiles, i, j, k, m, NFreqPnts=1601
	String FreqFile, S11Filenames, S11TempInt, NewName 
	
	WaveStats/Q $TempFilename
	NumFiles = V_npnts
	Wave/T Filenames=$Files
	Wave Temp = $TempFilename
	Wave Res = $Resistance 
	i = strsearch(Files,"T",0)
	FreqFile = Files[0,i-1]+"FrequencyRange"
	j=strsearch(Files,"T",Inf,1)
      
      //calculate average temperature and average resistance 
      Variable avg_T = 0.0, avg_R = 0.0
      k = 0
      Do
         avg_T += Temp[k]
         avg_R += Res[k]
         k=k+1
       while(k< NumFiles)
      avg_T = avg_T/(Numfiles+0.0)
      avg_R = avg_R/(Numfiles+0.0)
      print(avg_T)
      print(avg_R)
      NewName = NameofSam + "avg_" + num2str(avg_T)
      
      Make/O/N=(NFreqPnts)/C/D Avg 
      m=0
      Do 
          Avg[m] =cmplx(0,0)
          k= 0
         Do
          S11Filenames=NameofSam+"S11_"+Filenames[k]
         //print(S11Filenames)
          Wave/C S11_Old=$S11Filenames
          //print(real(S11_Old[m])
          Avg[m]+= cmplx(real(S11_Old[m]),imag(S11_Old[m]))
          k =k +1 
      while(k< NumFiles)
      m=m+1
      while(m< NFreqPnts)
      Avg = Avg /(Numfiles +0.0)
      
      String currentdatafolder = GetDataFolder(1)	
      NewDataFolder/O/S root:Calibrations
      String destination =  GetDataFolder(1)	
      Setdatafolder currentdatafolder
      MoveWave Avg, $destination
      Rename Avg $NewName 
End


//a new function that calculates error terms at 1 temperature.
Function CalErrOneT()
       string NDataSet="1"
	prompt NDataSet, "Data Set Number:"
	DoPrompt "Please input the index of the error terms set", NDataSet

	Variable i, j, m, k, NFreqPnts, LoadR=20.13, ContR =6, FreqMin, FreqDelta, FacLoad = 1, FacCont =1
	String OpenFileM, ShortFileM, LoadFileM, TempFile

	SetDataFolder Root:Calibrations

	Prompt OpenFileM, "Choose the file for open standard:", popup, Wavelist("**",";","DIMS:1")
	Prompt ShortFileM, "Choose the file for short standard:", popup, Wavelist("**",";","DIMS:1")
	Prompt LoadFileM, "Choose the file for load standard:", popup, Wavelist("**",";","DIMS:1")
	Prompt LoadR, "Please enter the resistance of load"
	Prompt FacLoad, "Please enter the capactitance factor for load"
	Prompt ContR, "Please enter a contact resistance"
	Prompt FacCont, "Please enter the capactitance factor for Contact"
	Doprompt "Choose the interpolated files for calibration standards", OpenFileM, ShortFileM, LoadFileM, LoadR, FacLoad, ContR, FacCont
	Wave/C OpenM=$OpenFileM, ShortM=$ShortFileM, LoadM=$LoadFileM

	NFreqPnts = DimSize($OpenFileM, 0)
	FreqMin = Dimoffset($OpenFileM, 0)
	FreqDelta = DimDelta($OpenFileM, 0)

	Variable  Z0=50, ZL
	Variable/C ShortA =cmplx(-1.0, 0), ComDen
	String GLoadA, GShortA

	//i=strsearch(ShortFileM, "I", Inf, 1)
	//GShortA = ShortFileM[0, i-1]+"A"
	//i=strsearch(LoadFileM, "I", Inf, 1)
	//GLoadA = LoadFileM[0, i-1]+"A"
	//LoadR = LoadFileM[0, i-1]+"RN"

	//Make/O/N=(NFreqPnts)/C $GLoadA
	//SetScale/P y Lowertemp, TempDelta, "", $GLoadA
	//SetScale/P x FreqMin, FreqDelta,"", $GLoadA
	//Wave/C LoadA=$GLoadA
          
        Make/O/C/N=1601 LoadI, LoadA, LoadC, OpenA, OpenI, OPenC
      
	 m=0
	 Do
	    LoadI[m] = conj(1/cmplx(1/LoadR, -1/LoadR*FacLoad/(NFreqPnts-1)*m)) + conj(1/cmplx(1/ContR, -1/ContR*FacCont/(NFreqPnts-1)*m))
	    OpenI[m]= conj(1/cmplx(1E-19, -1*0/LoadR*FacLoad/(NFreqPnts-1)*m)) + conj(1/cmplx(1/ContR, -1/ContR*FacCont/(NFreqPnts-1)*m))
	    m=m+1
       while(m<NFreqPnts)
       
       LoadA = (LoadI-Z0)/(LoadI+Z0)
      OpenA = (OpenI-Z0)/(OpenI+Z0)
       LoadC = conj(1/LoadI)
        OPenC = conj(1/OpenI)
	Newdatafolder/O/S root:ErrorTerms
	SetDataFolder root:ErrorTerms

	string ErrorS, ErrorD, ErrorR
	ErrorS="ES_DataSet_"+NDataSet
	ErrorD="ED_DataSet_"+NDataSet
	ErrorR="ER_DataSet_"+NDataSet
	Make/O/N=(NFreqPnts)/C/D $ErrorS, $ErrorD, $ErrorR
	//SetScale/P y Lowertemp, TempDelta, "", $ErrorS, $ErrorD, $ErrorR
	SetScale/P x FreqMin, FreqDelta,"", $ErrorS, $ErrorD, $ErrorR

	Wave/C LErrorS=$ErrorS, LErrorD=$ErrorD, LErrorR=$ErrorR
	string InfoNote=OpenFileM+", "+ShortFileM+", "+LoadFileM
	Note $ErrorS, InfoNote
	Note $ErrorD, InfoNote
	Note $ErrorR, InfoNote

	m=0
	Do

			ComDen = OpenM[m]*OpenA[m]*LoadA[m]-OpenA[m]*OpenM[m]*ShortA-OpenA[m]*LoadM[m]*LoadA[m]
			ComDen += -ShortM[m]*ShortA*LoadA[m]+ShortA*LoadM[m]*LoadA[m]+OpenA[m]*ShortA*ShortM[m]
			//print/D ComDen


			LErrorS[m] = ShortA*LoadM[m]-LoadM[m]*OpenA[m]+OpenM[m]*LoadA[m]
			LErrorS[m] += -ShortM[m]*LoadA[m]-OpenM[m]*ShortA+OpenA[m]*ShortM[m]
			LErrorS[m] /=ComDen
			//Print/D LErrorS[m]

			LErrorD[m] = -OpenA[m]*OpenM[m]*ShortM[m]*LoadA[m]+OpenA[m]*OpenM[m]*ShortA*LoadM[m]+OpenA[m]*LoadM[m]*ShortM[m]*LoadA[m]
			LErrorD[m] += OpenM[m]*LoadA[m]*ShortA*ShortM[m]-OpenM[m]*LoadA[m]*ShortA*LoadM[m]-OpenA[m]*LoadM[m]*ShortA*ShortM[m]
			LErrorD[m] /= -ComDen
			//Print/D LErrorD[m]

			LErrorR[m] = (OpenA[m]^2) *(OpenM[m]^2)*ShortM[m]*ShortA-LoadM[m]*(ShortM[m]^2)*(ShortA^2)*OpenA[m]-LoadM[m]*(OpenM[m]^2)*(OpenA[m]^2)*ShortA
			LErrorR[m] += -(OpenA[m]^2)*OpenM[m]*(ShortM[m]^2)*ShortA-(OpenM[m]^2)*(ShortA^2)*ShortM[m]*OpenA[m]+OpenM[m]*(ShortA^2)*(ShortM[m]^2)*OpenA[m]
			LErrorR[m] += -(OpenA[m]^2)*(LoadM[m]^2)*ShortA*ShortM[m]+(OpenA[m]^2)*LoadM[m]*ShortA*(ShortM[m]^2)-LoadM[m]*(LoadA[m]^2)*(ShortM[m]^2)*ShortA
			LErrorR[m] += -(LoadM[m]^2)*(LoadA[m]^2)*OpenM[m]*ShortA-(LoadM[m]^2)*(LoadA[m]^2)*ShortM[m]*OpenA[m]+(LoadM[m]^2)*(LoadA[m]^2)*ShortM[m]*ShortA
			LErrorR[m] += -LoadM[m]*(LoadA[m]^2)*(OpenM[m]^2)*OpenA[m]+(LoadM[m]^2)*(LoadA[m]^2)*OpenM[m]*OpenA[m]-(OpenA[m]^2)*(OpenM[m]^2)*ShortM[m]*LoadA[m]
			LErrorR[m] += -OpenM[m]*LoadA[m]*(ShortA^2)*(ShortM[m]^2)-ShortM[m]*(ShortA^2)*LoadA[m]*(LoadM[m]^2)-OpenM[m]*(OpenA[m]^2)*LoadA[m]*(LoadM[m]^2)
			LErrorR[m] += LoadM[m]*(ShortM[m]^2)*(ShortA^2)*LoadA[m]+LoadM[m]*(OpenM[m]^2)*(OpenA[m]^2)*LoadA[m]-(OpenM[m]^2)*LoadA[m]*(ShortA^2)*LoadM[m]
			LErrorR[m] += OpenA[m]*(OpenM[m]^2)*ShortM[m]*(LoadA[m]^2)-OpenA[m]*OpenM[m]*(ShortM[m]^2)*(LoadA[m]^2)+(OpenA[m]^2)*OpenM[m]*(ShortM[m]^2)*LoadA[m]
			LErrorR[m] += -OpenA[m]*OpenM[m]*(ShortA^2)*(LoadM[m]^2)+(OpenA[m]^2)*OpenM[m]*ShortA*(LoadM[m]^2)+OpenA[m]*(OpenM[m]^2)*(ShortA^2)*LoadM[m]
			LErrorR[m] += (OpenA[m]^2)*(LoadM[m]^2)*ShortM[m]*LoadA[m]+OpenA[m]*LoadM[m]*(ShortM[m]^2)*(LoadA[m]^2)-(OpenA[m]^2)*LoadM[m]*(ShortM[m]^2)*LoadA[m]
			LErrorR[m] += -(OpenM[m]^2)*(LoadA[m]^2)*ShortA*ShortM[m]+OpenM[m]*(LoadA[m]^2)*ShortA*(ShortM[m]^2)+(OpenM[m]^2)*LoadA[m]*(ShortA^2)*ShortM[m]
			LErrorR[m] += OpenM[m]*LoadA[m]*(ShortA^2)*(LoadM[m]^2)+(OpenM[m]^2)*(LoadA[m]^2)*ShortA*LoadM[m]+OpenA[m]*(LoadM[m]^2)*(ShortA^2)*ShortM[m]
			LErrorR[m] /= ComDen
			LErrorR[m] /= ComDen

			
		m=m+1

	While(m<NFreqPnts)

Killwaves OPenC, OpenI, OpenA, OpenC, LoadA, LoadI, LoadC

End


//a new function that calculates actual sample response at one temperature 
Function CalSam1T()
      String  SampleFile, ErrorS, ErrorD, ErrorR, GSampleA, GImpedanceA, GConductivityA, ImpSubA = "Subs"
	variable i, m, k, NFreqPnts, FreqMin, FreqDelta, Z0=50, g=5.281, LoadR= 20.13, ContR =6, FacLoad =1, FacCont =1
	
	SetDataFolder Root:Calibrations
	Prompt SampleFile, "Choose the file for the sample:", popup, Wavelist("**",";","DIMS:1")
	Prompt LoadR, "Please enter the resistance of load"
	Prompt FacLoad, "Please enter the capactitance factor for load"
	Prompt ContR, "Please enter a contact resistance"
	Prompt FacCont, "Please enter the capactitance factor for Contact"
	DoPrompt "Choose the interpolated file for the sample", SampleFile, LoadR, FacLoad, ContR,FacCont
	Wave/C SampleM=$SampleFile
	i = strsearch(SampleFile,"T",inf, 1)
	GSampleA= SampleFile[0, i-1]+"S22A"
	GImpedanceA=SampleFile[0, i-1]+"ImpedanceA"
	GConductivityA=SampleFile[0, i-1]+"ConductivityA"
	//NTempPnts = DimSize($SampleFile, 1)
	//LowerTemp = Dimoffset($SampleFile, 1)
	//TempDelta =DimDelta($SampleFile, 1)
	NFreqPnts = DimSize($SampleFile, 0)
	FreqMin = Dimoffset($SampleFile, 0)
	FreqDelta = DimDelta($SampleFile, 0)

	SetDataFolder Root:ErrorTerms
	Prompt ErrorS, "Choose the file for ES:", popup, Wavelist("ES*",";","")
	Prompt ErrorD, "Choose the file for ED:", popup, Wavelist("ED*",";","")
	Prompt ErrorR, "Choose the file for ER:", popup, Wavelist("ER*",";","")
	Doprompt "Choose the interpolated files for calibration standards", ErrorS, ErrorD, ErrorR
	Wave/C ES=$ErrorS, ED=$ErrorD, ER=$ErrorR

      NewDataFolder/O/S root:SampleActual 
	SetDataFolder root:SampleActual

	Make/O/N=(NFreqPnts)/C $GSampleA, $GImpedanceA, $GConductivityA, $ImpSubA
	//SetScale/P y Lowertemp, TempDelta, "", $GSampleA, $GImpedanceA, $GConductivityA
	SetScale/P x FreqMin, FreqDelta,"", $GSampleA, $GImpedanceA, $GConductivityA
	Wave/C SampleA=$GSampleA, ImpedanceA=$GImpedanceA, ConductivityA=$GConductivityA, ImpSub = $ImpSubA

	m=0
	Do
                   SampleA[m] = (SampleM[m]-ED[m])/(ER[m]+ES[m]*(SampleM[m]-ED[m]))
			ImpedanceA[m]= g*Z0*(1+SampleA[m])/(1-SampleA[m]) -  g*conj(1/cmplx(1/ContR, -1/ContR*FacCont/(NFreqPnts-1)*m))	
			ImpSub[m] = g* conj(1/cmplx(1/1E15, -1/LoadR*FacLoad/(NFreqPnts-1)*m))
			//g*cmplx(0, -1/(LoadR*FacLoad/(NFreqPnts-1)*m))			
			ImpedanceA[m] = ImpedanceA[m]*ImpSub[m]/(ImpSub[m]-ImpedanceA[m])		
			conductivityA[m]= conj (1/ImpedanceA[m])
			//k=k+1		
		m=m+1		
	While(m<NFreqPnts)
	Variable SumSA=0.0
	string InfoNote=ErrorS+", "+ErrorD+", "+ErrorR
	Note $GSampleA, InfoNote
	Note $GImpedanceA, InfoNote

End


Function CorrSubfromNorm1() //This function is used if you start with normal state SAMPLE Impedance! //for one temperature
	String  ImpedanceFile, GImpedance, SubstrateFile, GConductivity
	variable i, m, k, NFreqPnts, NTempPnts, LowerTemp, TempDelta, FreqMin, FreqDelta, scalefactor=ln(2.3/0.7)/2/pi, SamRes = 2500
	
	Prompt ImpedanceFile, "Choose the impedance file for the sample:", popup, Wavelist("*Impedance*",";","DIMS:1") 
	Prompt SubstrateFile, "Choose the substrate file:", popup, wavelist("**",";","DIMS:1") //This "substrate" file is usually normal state sample imedance file (say 6K) 
	Prompt SamRes, "Please enter the resistance of sample in the normal state"
	DoPrompt "Choose the corresponding file for the sample", ImpedanceFile, SubstrateFile, SamRes
	Wave/C Substrate=$SubstrateFile
	Wave/C Impedance = $ImpedanceFile
	
	//This step converts normal state impedance to "substrate impedance" However I don't want to change the imported wave. 
	Make/C/N=1601 Zsam = cmplx(SamRes, 0)
	Make/C/N=1601 Sub_Temp
	Sub_Temp = Substrate*Zsam / (Zsam-Substrate)		
	
	i = strsearch(ImpedanceFile,"I",inf, 1)
	GImpedance= ImpedanceFile[0, i-1]+"Impd_subcorr"
	GConductivity=ImpedanceFile[0, i-1]+"Cond_subcorr"
	i = strsearch(ImpedanceFile,"A",inf, 1)
	GImpedance=GImpedance + ImpedanceFile[i+1, inf]
	GConductivity=GConductivity + ImpedanceFile[i+1, inf]
	NTempPnts = DimSize($ImpedanceFile, 1)
	LowerTemp = Dimoffset($ImpedanceFile, 1)
	TempDelta =DimDelta($ImpedanceFile, 1)
	NFreqPnts = DimSize($ImpedanceFile, 0)
	FreqMin = Dimoffset($ImpedanceFile, 0)
	FreqDelta = DimDelta($ImpedanceFile, 0)


	Make/O/C/N=(NFreqPnts,NTempPnts) $GImpedance, $GConductivity
	Wave/C Impedcorr=$GImpedance, Condcorr=$GConductivity
	SetScale/P y Lowertemp, TempDelta, "", $GImpedance, $GConductivity
	SetScale/P x FreqMin, FreqDelta,"", $GImpedance, $GConductivity

	m=0
	Do
			Impedcorr[m]= Impedance[m]/(1-Impedance[m]/Sub_Temp[m])
			Condcorr[m] = conj(1/Impedcorr[m])
		m=m+1
		
	While(m<NFreqPnts)
	Killwaves Sub_Temp
End

//Interpolate substrate between two magnetic fields
Function IntpSub()

Variable NofFields=51,  NofFrequency=1601   //Number of fields after interpolation 
Variable lowF =0, highF = 0.5
Prompt NofFields, "Please input the desired number of error term datasets"
Prompt NofFrequency, "Please input the number of frequencies"
Prompt LowF, "lower magnetic field"
Prompt HighF, "higher magnetic field"
Doprompt "The number of error term datasets", NofFields, NofFrequency, LowF, highF

Variable  j=0 

String Sublow, Subhigh //declare the waves to be interpolated
Sublow = "Sub_" + num2str(LowF) + "T"
Subhigh = "Sub_" + num2str(HighF) + "T"
Wave/C SubA = $Sublow 
Wave/C SubB = $Subhigh

String TempSubName
//String CurrentDataFolder =  GetDataFolder(1)	
//NewDataFolder/O/S root:SampleActual
//String destination =  GetDataFolder(1)
//String Temp_destination  = destination, SubFolderName = "0T"
//Setdatafolder currentdatafolder

For(j=0;j<NofFields;j=j+1)
 Make/O/C/N=(NofFrequency) TempSub
 TempSub = ((NofFields-1-j)*SubA + j*SubB)/(NofFields-1+0.0)
 TempSubName = "Sub_Int_" +  num2str(LowF+j*(HighF-LowF)/(NofFields-1)) + "T"
 //Setdatafolder destination
 //SubFolderName = num2str(LowF+j*(HighF-LowF)/(NofFields-1)) + "T"
 //NewDataFolder/O/S root:SampleActual:SubFolderName
 //Temp_destination =  GetDataFolder(1)
 //Movewave TempSub $Temp_destination
 Rename TempSub $TempSubName
 //Setdatafolder currentdatafolder
Endfor 

End


//a new function which takes the data at the same temperature and same frequency and averages it.
Function LoadOneTemp1() 
       String Files, TempFilename, Resistance, NameofSam="IT_"
	Variable NTempPnts=10 
	Prompt Files, "Choose the filenames file:", popup, Wavelist("*Time*",";","DIMS:1")
	Prompt TempFilename, "Choose the temperature file:", popup, Wavelist("*Sample*",";","DIMS:1")
	Prompt Resistance, "Choose the resistance file",popup, Wavelist("*Res*",";","DIMS:1")
	Prompt NTempPnts, "Enter the number of temperature points"
	Prompt NameofSam, "Enter the name of the sample"
	Doprompt "The data to be averaged", Files, TempFilename, Resistance, NTempPnts, NameofSam
 
 
      	variable NumFiles, i, j, k, m
	String FreqFile, S11Filenames, S11TempInt, NewName 
	
	WaveStats/Q $TempFilename
	NumFiles = V_npnts
	Wave/T Filenames=$Files
	Wave Temp = $TempFilename
	Wave Res = $Resistance 
	i = strsearch(Files,"T",0)
	FreqFile = Files[0,i-1]+"FrequencyRange"
	j=strsearch(Files,"T",Inf,1)
      
      //get the number of frequency points
       S11Filenames=NameofSam+"S11_"+Filenames[0]
      variable NFreqPnts=numpnts($S11Filenames)
      
      //calculate average temperature and average resistance 
      Variable avg_T = 0.0, avg_R = 0.0
      k = 0
      Do
         avg_T += Temp[k]
         avg_R += Res[k]
         k=k+1
       while(k< NumFiles)
      avg_T = avg_T/(Numfiles+0.0)
      avg_R = avg_R/(Numfiles+0.0)*5.281
      print(avg_T)
      print(avg_R)
      NewName = NameofSam + "avg_" + num2str(avg_T)      
      
      Variable/C Avg = cmplx(0,0)
      m=0
      Do 
          k= 0
         Do
          S11Filenames=NameofSam+"S11_"+Filenames[k]
          Wave/C S11_Old=$S11Filenames
          Avg+= cmplx(real(S11_Old[m]),imag(S11_Old[m]))
          k =k +1 
      while(k< NumFiles)
      m=m+1
      while(m< NFreqPnts)
      Avg = Avg /(Numfiles +0.0)/(NFreqPnts+0.0)
      
      Print Avg
      
      Make/N=1/C Avg_wave 
      Avg_wave[0] = Avg
      
      String currentdatafolder = GetDataFolder(1)	
      NewDataFolder/O/S root:Calibrations
      String destination =  GetDataFolder(1)	
      Setdatafolder currentdatafolder
      MoveWave Avg_wave, $destination
      Rename Avg_wave $NewName 
End



Function CalSa() //This function calculates Sa from Sm for one frequency and one temperature
	
	String SmFile, ErrTFile, SubFile
	//SmFile is actually a function of power, e.g., from -30dbm to -10dbm
		
	//Error terms need to be in the order of Es, Ed, Er. Note that here we use the same error coefficients for both substrate and sample cailbrations to reduce error
	
	//SubFile is the measured reflection coefficient of the sample in the normal state, typically 4K, From this we need to calculate the calibrated reflection coefficeint and the impedance
	//Since in the subFile power dependence is neglible the subfile wave has only one row
	Variable SamRes = 2000 //sample resistance in the normal state
	
	
	Prompt SmFile, "Choose file for measured refllection:", popup, Wavelist("**",";","DIMS:1") 
	Prompt ErrTFile, "Choose file for the error terms:",  popup, wavelist("**",";","DIMS:1") 
	Prompt SubFile, "Choose file for normal state measured refelction:",  popup, wavelist("**",";","DIMS:1") 
	Prompt SamRes, "Please enter the resistance of sample in the normal state"
	DoPrompt "Choose the corresponding files", SmFile,  ErrTFile, SubFile, SamRes
	
	Wave/C Sm = $SmFile
	Wave/C ErrT = $ErrTFile
	Wave/C Sub = $SubFile
	
	Variable m= 0, NPoints =21 //NPoints the number of power points
	
	Variable/C Es, Ed, Er
	
	Es = cmplx(ErrT[0],ErrT[1])
	Ed = cmplx(ErrT[2],ErrT[3])
	Er = cmplx(ErrT[4],ErrT[5])
	
	//Make a wave for Sa 
	Make/C/N=21 Sa =cmplx(0,0)
	
      m = 0
      Do 
      Sa[m] = (Sm[m]-Ed)/(Er+Es*(Sm[m]-Ed))
      m=m+1
      while(m<NPoints)
      
      //Now we deal with the normal state
      Variable/C NSSa, NSImpA
      //Normal state refelction coeffiecient and normal state impedance
      
      Variable g = 2*Pi/ln(2.3/0.7)
      //the Corbino factor 
      
      NSSa =  (Sub[0]-Ed)/(Er+Es*(Sub[0]-Ed))
      Print "NSSa", NSSa
     
      NSImpA = g * (1+NSSa)/(1-NSSa)*50
      Print "NSImpA",  NSImpA 
      
      //Assuming normal state sample impedance is given by resistance
      Variable/C ZSam = cmplx(SamRes, 0)
	Variable/C SubActual
	SubActual =NSImpA *Zsam / (Zsam-NSImpA )	
	//So here we obtain the substrate impedance 
	
	//For simplicity we calculate sample impedance
	//Make a wave for Sample impedance
      Make/C/N=21 Simp =cmplx(0,0), SimpCorr = cmplx(0,0)
	Simp = g*50*(1+Sa)/(1-Sa)
	
	SimpCorr = Simp/(1-Simp/SubActual)
	Print SimpCorr
	
	//Now we turn to correct Sa 
	Sa = ((SimpCorr/g)-50)/((SimpCorr/g)+50)

End

Function CutData() //For real waves 

//Thickness in nm 
Variable Thickness = 20, StartPos =17, EndPos = 100

Prompt Thickness, "Thickness of the film in nm"
Prompt StartPos, "Starting point for cutting"
Prompt EndPos, "Endpoint for cutting"
Doprompt "Enter thickness, start, and end", Thickness, StartPos, EndPos

String ListofWaves = WaveList("*",";","")

Variable NofWaves = itemsinlist(ListofWaves)

Print "Num of waves in the folder is" + num2str(NofWaves)

//iteration variables 
Variable i = 0, j =0 

//Temporary string for the sake of cutting 
String Temp ="Sigma"
//this string is used for the new cut wave 
String Temp1 = Temp + "_cut1"
String Temp2 = Temp + "_cut2"

for(i=0;i<NofWaves;i+=1)

 Temp = stringfromlist(i,ListofWaves)

 
 Temp1 = Temp + "_cut1"
 Temp2 = Temp + "_cut2"
 Wave/C TempWave = $Temp 

 TempWave = TempWave/Thickness*1E7
 
 Wave TempWave1 = $Temp1
 Wave TempWave2 = $Temp2
 
 Duplicate/O/R=[StartPos,EndPos] $Temp , $Temp1
 Duplicate/O/R=[StartPos,EndPos] $Temp , $Temp2 
 
 TempWave1 =real(TempWave)
 TempWave2 = imag(TempWave)
 
endfor

End


Function AvgWave() //average of a real wave, e,g, for Faraday rotation

Variable  StartPos =14, EndPos = 139

Prompt StartPos, "Starting point for avg"
Prompt EndPos, "Endpoint for avg"
Doprompt "Enter start, and end",  StartPos, EndPos

String ListofWaves = WaveList("*",";","")

Variable NofWaves = itemsinlist(ListofWaves)
Print "Num of waves in the folder is" + num2str(NofWaves)
Make/O/N=20 AvgRotation 

//iteration variables 
Variable i = 0, j =0, summation =0 

//Temporary string for the sake of calculating avg 
String Temp ="F"


for(i=0;i<NofWaves;i+=1)

 Temp = stringfromlist(i,ListofWaves)
 Wave TempWave = $Temp
 summation=0
 for(j=StartPos;j<EndPos;j+=1)
    summation+= TempWave[j]
 endfor 
 AvgRotation[i] = summation/(EndPos-StartPos)

endfor
End

//Function AvgWave() //average of a real wave, e,g, for Faraday rotation

//String FWave ="F"
//Variable  StartPos =14, EndPos = 139

//Prompt FWave, "Choose file for measured refllection:", popup, Wavelist("**",";","DIMS:1") 
//Prompt StartPos, "Starting point for avg"
//Prompt EndPos, "Endpoint for avg"
//Doprompt "Enter start, and end",  FWave, StartPos, EndPos

//iteration variables 
//Variable  j =0, summation =0, AvgRotation  =0 
//Wave TempWave = $FWave
//for(j=StartPos;j<EndPos;j+=1)
    summation+= TempWave[j]
//endfor 
// AvgRotation = summation/(EndPos-StartPos)

//Print AvgRotation 
//End
