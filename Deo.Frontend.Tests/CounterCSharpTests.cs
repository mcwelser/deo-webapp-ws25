using Deo.Frontend.Components.Pages;
using Moq;

namespace Deo.Frontend.Tests;

public class CounterCSharpTests : TestContext
{
    [Fact]
    public void LocalCounterStartsAtZero()
    {
        var sut = RenderComponent<LocalCounter>();

        sut.Find("p").MarkupMatches("<p role=\"status\">Current count: 0</p>");
    }

    [Fact]
    public void LocalCounterIncrementsByOne()
    {
        var sut = RenderComponent<LocalCounter>();

        sut.Find("button:contains('Increment')").Click();

        var countParagraph = sut.Find($"p[role='status']:contains('Current count')");
        countParagraph.TextContent.MarkupMatches($"Current count: 1");
    }

    [Fact]
    public void ServiceCounterShowsResultFromCounterService()
    {
        var counterServiceMock = new Mock<ICounterService>();
        const int expected = 0;

        counterServiceMock.Setup(x => x.GetValueAsync()).Returns(Task.FromResult(expected));
        Services.AddSingleton(counterServiceMock.Object);

        var sut = RenderComponent<ServiceCounter>();

        sut.Find("p").MarkupMatches($"<p role=\"status\">Current count: {expected}</p>");
    }
}
