namespace Sirenix.OdinInspector.Editor.Examples
{
	[AttributeExample(typeof(PropertyTooltipAttribute), "PropertyTooltip is used to add tooltips to properties in the inspector.\n\nPropertyTooltip can also be applied to properties and methods, unlike Unity's Tooltip attribute.")]
	internal class PropertyTooltipExamples
	{
		[PropertyTooltip("This is tooltip on an int property.")]
		public int MyInt;

		[InfoBox("Use $ to refer to a member string.", InfoMessageType.Info, null)]
		[PropertyTooltip("$Tooltip")]
		public string Tooltip = "Dynamic tooltip.";

		[Button]
		[PropertyTooltip("Button Tooltip")]
		private void ButtonWithTooltip()
		{
		}
	}
}
