namespace Sirenix.OdinInspector.Editor.Examples
{
	[AttributeExample(typeof(LabelTextAttribute), "Specify a different label text for your properties.")]
	internal class LabelTextExamples
	{
		[LabelText("1")]
		public int MyInt1 = 1;

		[LabelText("2")]
		public int MyInt2 = 12;

		[LabelText("3")]
		public int MyInt3 = 123;

		[InfoBox("Use $ to refer to a member string.", InfoMessageType.Info, null)]
		[LabelText("$MyInt3")]
		public string LabelText = "The label is taken from the number 3 above";

		[InfoBox("Use @ to execute an expression.", InfoMessageType.Info, null)]
		[LabelText("@DateTime.Now.ToString(\"HH:mm:ss\")")]
		public string DateTimeLabel;
	}
}
