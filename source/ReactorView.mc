import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ReactorView extends WatchUi.WatchFace {

    // Pre-allocated widgets & data providers (zero memory allocations in loop)
    private var _dataProvider as DataProvider;
    private var _themeConfig as Theme.ThemeConfig;
    
    private var _headerWidget as HeaderWidget;
    private var _chartWidget as ChartWidget;
    private var _timeWidget as TimeWidget;
    private var _flankWidget as FlankWidget;
    private var _bottomMetricsWidget as BottomMetricsWidget;

    function initialize() {
        WatchFace.initialize();
        
        _dataProvider = new DataProvider();
        _themeConfig = new Theme.ThemeConfig();
        
        _headerWidget = new HeaderWidget();
        _chartWidget = new ChartWidget();
        _timeWidget = new TimeWidget();
        _flankWidget = new FlankWidget();
        _bottomMetricsWidget = new BottomMetricsWidget();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        // 1. Update data metrics
        _dataProvider.updateMetrics();
        _themeConfig.loadProperties();

        // 2. Clear canvas with pure AMOLED black
        dc.setColor(Theme.COLOR_BG, Theme.COLOR_BG);
        dc.clear();

        // 3. Render all 5 layout zones
        _headerWidget.draw(dc, _dataProvider, _themeConfig);
        _chartWidget.draw(dc, _dataProvider, _themeConfig);
        _timeWidget.draw(dc, _dataProvider, _themeConfig);
        _flankWidget.draw(dc, _dataProvider, _themeConfig);
        _bottomMetricsWidget.draw(dc, _dataProvider, _themeConfig);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
        _themeConfig.isAod = false;
        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
        _themeConfig.isAod = true;
        WatchUi.requestUpdate();
    }
}
