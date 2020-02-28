function alarm()
	speaker = nil;
	toConsole = true;
	for _,name in pairs(peripheral.getNames()) do
		if(peripheral.getType(name) == "speaker") then
			speaker = peripheral.wrap(name);
			toConsole = false;
		end
	end	
	if(speaker == nil) then 
		print ( "Speaker not found, speaking to console")
		while not (os.pullEvent() == "reactor_fixed") do
			speaker.speak("danger")
			sleep(1)
		end
	else
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.red)
		print("REACTOR ALERT\n")
	end
	
end
function check()

	message = os.pullEvent("rednet_message")
	if(message == nil) then
	else
		if(message > 0 ) then 
			alarm()
		end
		
	end
	
	

end


modem = nil;

for _,name in pairs(peripheral.getNames()) do
	if(peripheral.getType(name) == "modem") then
		modem = peripheral.wrap(name);
		
	end
end	

modem.open(5)




batboxes = 0
cesus = 0
mfes = 0
mfsus = 0
mon = 0
modems = 0
reactors = 0
debug = 0
 
  term.clear()
  term.setCursorPos(1, 1)
  print("Press any key for debug mode.")
  while true do
    os.startTimer(3)
    local event = os.pullEvent()
    if event == "timer" then break
    else
      debug = 1
      break
    end
	check()
  end
term.clear()
 
term.setCursorPos(1, 1)
if debug == 1 then
  print("Scanning for connected IC2 storage devices...")
  sleep(2)
  print("Peripherals detected:\n")
  sleep(0.5)
end
tBatbox = {}
tCesu = {}
tMfe = {}
tMfsu = {}
tMon = {}
tMonName = {}
tModem = {}
tReactors = {}
 
for _,name in pairs(peripheral.getNames()) do
  if debug == 1 then
    print(name.." "..peripheral.getType(name))
    sleep(0.15)
  end
  if peripheral.getType(name):match"batbox" then
    batboxes = batboxes+1
    tBatbox[#tBatbox+1] = peripheral.wrap(name)
    elseif peripheral.getType(name):match"cesu" then
      cesus = cesus+1
      tCesu[#tCesu+1] = peripheral.wrap(name)
    elseif peripheral.getType(name):match"mfe" then
      mfes = mfes+1
      tMfe[#tMfe+1] = peripheral.wrap(name)
    elseif peripheral.getType(name):match"mfsu" then
      mfsus = mfsus+1
      tMfsu[#tMfsu+1] = peripheral.wrap(name)
	elseif peripheral.getType(name):match"reactor" then
      reactors = reactors+1
      tMfsu[#tMfsu+1] = peripheral.wrap(name)
    elseif peripheral.getType(name) == "monitor" then
      mon = mon+1
      tMonName[mon] = name
      tMon[mon] = peripheral.wrap(name)
          tMon[mon].clear()
	elseif peripheral.getType(name) == "modem" then
		modems = modems +1
		tModem[modems] = name
		tModem[modems] = peripheral.wrap(name)
		if rednet.isOpen(name) then
			print("RedNet already opened at "..name)
		else
			rednet.open(name)
			print("RedNet opened at "..name)
		end
  end
end

 
if debug == 1 then
  sleep(2)
  term.clear()  
  term.setCursorPos(1, 1)
  sleep(0.25)
end
total = batboxes+cesus+mfes+mfsus
 
  if total > 0 then
    print("The following storage devices are connected:\n")
    sleep(1)
    print("Batbox:  ", batboxes)
    sleep(0.25)
    print("CESU:    ", cesus)
    sleep(0.25)
    print("MFE:     ", mfes)
    sleep(0.25)
    print("MFSU:    ", mfsus)
	sleep(0.25)
	print("Modems:\t", modems)
        sleep(1)
    else
      debug = 1
      term.setTextColor(colors.red)
      print("ERROR!\n\nNo storage devices found!\n\nTerminating.")
      term.setTextColor(colors.white)
      os.exit()
  end
 
if debug == 1 then
  print(" ")
  if batboxes > 0 then
    for i = 1,batboxes do
      print("Wrapped batbox at \"tBatbox[", i, "]\"")
      sleep(0.15)
    end
  end
  print(" ")
  if cesus > 0 then
    for i = 1, cesus do
      print("Wrapped CESU at \"tCesu[", i, "]\"")
      sleep(0.15)
    end
  end
  print(" ")
  if mfes > 0 then
    for i = 1, mfes do
      print("Wrapped MFE at \"tMfe[", i, "]\"")
      sleep(0.15)
    end
  end
  print(" ")
  if mfsus > 0 then
    for i = 1, mfsus do
      print("Wrapped MFSU at \"tMfsu[", i, "]\"")
      sleep(0.15)
    end
  end
  sleep(5)
end
term.clear()
sleep(0.15)
term.setCursorPos(1, 1)
print("Ready to monitor ", total, " energy storage devices.")
sleep(0.5)
 
--Device detection and wrapping complete
 
if mon > 0 then
        print("\nWhere do you want to output the data?\n")
        sleep(0.15)
        print("0 - this terminal")
        for i = 1,mon do
                print(i, " - ", tMonName[i])
        end
       
        while true do
                monout = io.read()
                monout = tonumber(monout)
                if (monout > 0) and (monout < mon+1) then
                        monitor = tMon[monout]
                        break
                elseif monout == 0 then
                        monitor = term
                        break
                elseif mon == 0 then
                        monitor = term
                        break
                else print("Not a valid output.")
                end
        end
end
 
pbat = {}
fbat = {}
pces = {}
fces = {}
pmfe = {}
fmfe = {}
pmfs = {}
fmfs = {}
totalCap = 0
 
if batboxes > 0 then
  cbat = tBatbox[1].getEUCapacity()
  totalCap = totalCap+cbat*batboxes
end
 
if cesus > 0 then
  cces = tCesu[1].getEUCapacity()
  totalCap = totalCap+cces*cesus
end
 
if mfes > 0 then
  cmfe = tMfe[1].getEUCapacity()
  totalCap = totalCap+cmfe*mfes
end
 
if mfsus > 0 then
  cmfs = tMfsu[1].getEUCapacity()
  totalCap = totalCap+cmfs*mfsus
end
 
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num*mult+0.5)/mult
end
 
while true do
        monitor.clear()
        monitor.setCursorPos(1, 1)
        monitor.write("Unit  |  EU stored | EU capacity | Fill")
        monitor.setCursorPos(1, 2)
        monitor.write("------+------------+-------------+-----")
        line = 3
        totalFill = 0
 
  for i = 1,batboxes do
    pbat[i] = tBatbox[i].getEUStored()
    fbat[i] = round(pbat[i]/cbat*100, 0)
        totalFill = totalFill+pbat[i]
        if pbat[i] < 10 then
                length = 4
        elseif pbat[i] < 100 then
                length = 3
        elseif pbat[i] < 1000 then
                length = 2
        elseif pbat[i] < 10000 then
                length = 1
        else
                length = 0
        end
 
        if pbat[i] == 0 then
                fbat[i] = 0
                lengthf = 2
        elseif fbat[i] < 10 then
                lengthf = 2
        elseif fbat[i] < 100 then
                lengthf = 1
        else
                lengthf = 0
        end
       
        monitor.setCursorPos(1, line)
        monitor.write("BatB"..i.." |")
        monitor.setCursorPos(14+length, line)
        monitor.write(pbat[i].." |")
        monitor.setCursorPos(28, line)
        monitor.write(cbat.." |")
        monitor.setCursorPos(36+lengthf, line)
        monitor.write(fbat[i].."%")
        line = line+1
  end
 
  for i = 1,cesus do
    pces[i] = tCesu[i].getEUStored()
    fces[i] = round(pces[i]/cces*100, 0)
        totalFill = totalFill+pces[i]
        if pces[i] < 10 then
                length = 5
        elseif pces[i] < 100 then
                length = 4
        elseif pces[i] < 1000 then
                length = 3
        elseif pces[i] < 10000 then
                length = 2
        elseif pces[i] < 100000 then
                length = 1
        else
                length = 0
        end
 
        if pces[i] == 0 then
                fces[i] = 0
                lengthf = 2
        elseif fces[i] < 10 then
                lengthf = 2
        elseif fces[i] < 100 then
                lengthf = 1
        else
                lengthf = 0
        end
                monitor.setCursorPos(1, line)
                monitor.write("CESU"..i.." |")
                monitor.setCursorPos(13+length, line)
                monitor.write(pces[i].." |")
                monitor.setCursorPos(27, line)
                monitor.write(cces.." |")
                monitor.setCursorPos(36+lengthf, line)
                monitor.write(fces[i].."%")
                line = line+1
 
  end
 
  for i = 1, mfes do
    pmfe[i] = tMfe[i].getEUStored()
    fmfe[i] = round(pmfe[i]/cmfe*100, 0)
        totalFill = totalFill+pmfe[i]
        if pmfe[i] < 10 then
                length = 6
        elseif pmfe[i] < 100 then
                length = 5
        elseif pmfe[i] < 1000 then
                length = 4
        elseif pmfe[i] < 10000 then
                length = 3
        elseif pmfe[i] < 100000 then
                length = 2
        elseif pmfe[i] < 1000000 then
                length = 1
        else
                length = 0
        end
 
        if pmfe[i] == 0 then
                fmfe[i] = 0
                lengthf = 2
        elseif fmfe[i] < 10 then
                lengthf = 2
        elseif fmfe[i] < 100 then
                lengthf = 1
        else
                lengthf = 0
        end
 
                monitor.setCursorPos(1, line)
                monitor.write("MFE"..i.."  |")
                monitor.setCursorPos(12+length, line)
                monitor.write(pmfe[i].." |")
                monitor.setCursorPos(26, line)
                monitor.write(cmfe.." |")
                monitor.setCursorPos(36+lengthf, line)
                monitor.write(fmfe[i].."%")
                line = line+1
 
  end
 
  for i = 1, mfsus do
    pmfs[i] = tMfsu[i].getEUStored()
    fmfs[i] = round(pmfs[i]/cmfs*100, 0)
        totalFill = totalFill+pmfs[i]
        if pmfs[i] < 10 then
                length = 7
        elseif pmfs[i] < 100 then
                length = 6
        elseif pmfs[i] < 1000 then
                length = 5
        elseif pmfs[i] < 10000 then
                length = 4
        elseif pmfs[i] < 100000 then
                length = 3
        elseif pmfs[i] < 1000000 then
                length = 2
        elseif pmfs[i] < 10000000 then
                length = 1
        else
                length = 0
        end
 
        if pmfs == 0 then
                fmfs[i] = 0
                lengthf = 2
        elseif fmfs[i] < 10 then
                lengthf = 2
        elseif fmfs[i] < 100 then
                lengthf = 1
        else
                lengthf = 0
        end
 
                monitor.setCursorPos(1, line)
                monitor.write("MFSU"..i.." |")
                monitor.setCursorPos(11+length, line)
                monitor.write(pmfs[i].." |")
                monitor.setCursorPos(25, line)
                monitor.write(cmfs.." |")
                monitor.setCursorPos(36+lengthf, line)
                monitor.write(fmfs[i].."%")
                line = line+1
 
  end
  
  if(batboxes > 0) then
		for i = 1,batboxes do
			if(fbat[i] < 80) then
				alarm();
			end
		end
	end
  if total < 17 then
        monitor.setCursorPos(1, 19)
        monitor.setBackgroundColor(colors.gray)
        totalFill = totalFill / totalCap * 100
        monitor.write("                                       ")
        fFilled = totalFill*0.39
        fFilled = round(fFilled, 0)
        for i = 1, fFilled do
                monitor.setBackgroundColor(colors.white)
                monitor.setCursorPos(i, 19)
                monitor.write(" ")
                end
        end
        monitor.setBackgroundColor(colors.black)
  sleep(0.1)
end