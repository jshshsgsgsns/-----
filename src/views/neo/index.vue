<template>
    <div class="Echarts">
        <div id="main" style="width: 100%;height: 100%"></div>
    </div>
</template>
 
<script>
import * as echarts from 'echarts';

let data = [{
    name: '校园大数据',
    draggable: true,
    category: 0,
    itemStyle: {
        normal: {
        }
    }
},
{
    name: '舆情大数据',
    // symbolSize: 100,
    itemStyle: {
        normal: {
        }
    },
    category: 1,

},
{
    name: '用户分析',
    // symbolSize: 80,
    category: 1,
    itemStyle: {
        normal: {
        }
    },

},
{
    name: '话题分析',
    // symbolSize: 80,
    category: 1,
    itemStyle: {
        normal: {
        }
    },

},
{
    name: '评论分析',
    // symbolSize: 80,
    category: 1,
    itemStyle: {
        normal: {
        }
    },

},
{
    name: '图书馆分析',
    // symbolSize: 100,
    category: 2,
    itemStyle: {
        normal: {
        }
    },

},
{
    name: '借阅分析',
    // symbolSize: 80,
    category: 2,
    itemStyle: {
        normal: {
        }
    },
},
{
    name: '借阅排行',
    // symbolSize: 80,
    itemStyle: {
        normal: {
        }
    },
    category: 2,

},
{
    name: '图书收录',
    // symbolSize: 80,
    itemStyle: {
        normal: {
        }
    },
    category: 2,

},
{
    name: '图书分析',
    // symbolSize: 80,
    category: 2,
    itemStyle: {
        normal: {
            color: red
        }
    },

}]

let links = [{
    source: '校园大数据',
    target: '舆情大数据'
},
{
    source: '校园大数据',
    target: '图书馆分析',
},
{
    source: '舆情大数据',
    target: '用户分析',
},
{
    source: '舆情大数据',
    target: '话题分析',
},
{
    source: '舆情大数据',
    target: '评论分析',
},
{
    source: '校园大数据',
    target: '图书馆分析',
},
{
    source: '图书馆分析',
    target: '图书分析',
},
{
    source: '图书馆分析',
    target: '借阅分析',
},
{
    source: '图书馆分析',
    target: '借阅排行',
    value: 'DNA',
}, {
    source: '图书馆分析',
    target: '图书收录'

}, {
    source: '图书馆分析',
    target: '舆情大数据'

}, {
    source: '图书分析',
    target: '图书收录',
}]

let categories = [
    { name: '0' },
    { name: '1' },
    { name: '2' }
]

export default {
    name: 'Echarts',
    methods: {
        myEcharts() {
            var myChart = echarts.init(document.getElementById('main'));
            //配置图表
            var option = {
                tooltip: {},
                legend: [
                    {
                        data: categories.map(function (a) {
                            return a.name;
                        })
                    }
                ],
                series: [
                    {
                        type: 'graph',
                        layout: 'force',
                        force: {
                            repulsion: 1000,
                            edgeLength: 100
                        },
                        roam: true,
                        label: {
                            show: true,
                            position: 'right',
                            formatter: '{b}'
                        },
                        data: data,
                        links: links,
                        lineStyle: {
                            color: 'source',
                            curveness: 0.3
                        },
                        labelLayout: {
                            hideOverlap: true
                        },
                        scaleLimit: {
                            min: 0.4,
                            max: 2
                        },
                        categories: [
                            { name: '0' },
                            { name: '1' },
                            { name: '2' }
                        ]
                    }
                ]
            };
            myChart.setOption(option);
        }
    },
    mounted() {
        this.myEcharts();
    }
}
</script>
 
<style>
.Echarts {
    width: 100%;
    height: 100vh;
}
</style>