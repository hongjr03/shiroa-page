#import "template.typ": *
#import "@preview/tablex:0.0.8": tablex, cellx, rowspanx, colspanx, vlinex, hlinex
#import "@preview/cetz:0.2.2"

#import "/book.typ": book-page

#show: book-page.with(title: "实验 2：天气查询小程序")


#let title = "实验 2：天气查询小程序"
#let author = "洪佳荣"
#let course_id = "移动软件开发"
#let instructor = "高峰老师"
#let semester = "2024夏季"
#let due_time = "2024年8月20日"
#let id = "22070001035"

#show: assignment_class.with(title, author, course_id, instructor, semester, due_time, id)

// #show figure.caption: it => [
//   #set text(size: 9pt)
//   // #v(-1.5em)
//   #it
// ]

*源代码*：#link("https://github.com/hongjr03/MiniProgram")\
*博客*：暂未更新

= 实验目的
<实验目的>

1. 掌握服务器域名配置和临时服务器部署；
2. 掌握 wx.request 接口的用法。

= 实验步骤

#prob[API密钥申请和配置][
  首先从和风天气官网申请一个免费的 API 密钥，用于查询天气信息。
  #figure(image("assets/2024-08-19-21-18-10.png", width: 60%))
  #figure(image("assets/2024-08-19-21-21-22.png", width: 60%))
  根据官网的#link("https://dev.qweather.com/docs/configuration/api-config/")[API 配置文档]，要调取这个接口，需要使用以下 URL：
  ```
  https://devapi.qweather.com/v7/weather/now?location=xxx&key=xxx
  ```

  要正确使用这个接口，需要在微信开发者工具中配置服务器域名，将 `devapi.qweather.com` 添加到 request 合法域名中。

  #figure(image("assets/2024-08-19-21-31-07.png", width: 80%))
]

#prob[创建小程序][
  这里直接基于上一次实验的空白小程序继续开发。复制项目后，下载老师提供的图标素材，放到项目的对应目录下。目录结构如下：
  ```
  .
  ├─images
  │  ├─weather_icon_s1_bw
  │  ├─weather_icon_s1_color
  │  └─weather_icon_s2
  ├─pages
  │  └─index
  └─utils
  ```
]

#prob[视图设计][
  根据实验文档，进行页面设计。主要包括：
  - 页面中央的城市显示、温度、天气图标
  - 页面下方的天气数据列表

  涉及的代码可见#link("https://github.com/hongjr03/MiniProgram/commit/0af9ff0dbcad2f83ff65d980f568c06c9477ca5e")[commit]。

  #figure(
    image("assets/2024-08-19-23-43-01.png", width: 60%),
  )
]

#prob[逻辑实现][
  省市区信息

  #figure(image("assets/2024-08-20-00-07-05.png", width: 60%))

  自动刷新天气

  #figure(image("assets/2024-08-20-00-07-21.png", width: 60%))

  注意到一直出现返回400的错误，查看请求头。

  #figure(image("assets/2024-08-20-00-08-04.png", width: 50%))

  发现 location 为一串字符，而根据#link("https://dev.qweather.com/docs/api/weather/weather-now/")[API 文档]可知 location 应该为查询地区的LocationID或以英文逗号分隔的经纬度坐标。注意到老师给的文件中 utils 文件夹下有一个城市的 LocationID 数组和一个转换的方法，于是将这个方法引入到 index.js 中。使用 ```js location: util.getLocationID(that.data.region[1]), ``` 传入 location 参数。

  #figure(image("assets/2024-08-20-00-11-32.png", width: 60%))

  修复后，可以正常获取天气信息。返回的是一个 JSON 对象，需要解析后才能使用，结构为：

  ```json
  {
    "code":"200","updateTime":"2024-08-20T00:03+08:00",
    "fxLink":"https://www.qweather.com/weather/hangzhou-101210101.html",
    "now":{
      "obsTime":"2024-08-20T00:00+08:00",
      "temp":"30",
      "feelsLike":"33",
      "icon":"151",
      "text":"多云",
      "wind360":"135",
      "windDir":"东南风",
      "windScale":"2",
      "windSpeed":"10",
      "humidity":"71",
      "precip":"0.0",
      "pressure":"999",
      "vis":"30",
      "cloud":"91",
      "dew":"25"
    },
    "refer":{
      "sources":["QWeather"],
      "license":["CC BY-SA 4.0"]
    }
  }
  ```

  根据返回的 JSON 对象，将数据渲染到页面上。

  ```js
  that.setData({
    temp: res.data.now.temp,
    weather: res.data.now.text,
    icon: res.data.now.icon,
    humidity: res.data.now.humidity,
    pressure: res.data.now.pressure,
    visibility: res.data.now.vis,
    windDir: res.data.now.windDir,
    windSpeed: res.data.now.windSpeed,
    windScale: res.data.now.windScale,
  });
  ```

  #figure(image("assets/2024-08-20-00-21-34.png", width: 60%))

]

= 程序运行结果
<程序运行结果>

#grid(columns: (1fr, 1fr, 1fr))[
  #image("assets/2024-08-20-00-24-18.png")
][
  #image("assets/2024-08-20-00-24-26.png")
][
  #image("assets/2024-08-20-00-24-34.png")
]

= 问题总结与体会
<问题总结与体会>

