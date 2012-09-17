function main(... Params)
{

	if !${LavishScript.Executable.Find["ExeFile.exe"](exists)}
	{
	   Script:End
	}
	 echo "Starting RGWrapper"
	 echo "Using account" ${Params[1]}
	 OSExecute rgwrapper.exe ${Params[1]}
	 Script:End
}