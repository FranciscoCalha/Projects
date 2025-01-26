import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output, State
import dash_daq as daq
from dash import callback_context
import dash_bootstrap_components as dbc
from matplotlib import markers
import numpy as np
import pandas as pd
from skimage import io
import plotly.graph_objs as go
import plotly.express as px



path ='https://raw.githubusercontent.com/m20210672/Data-Visualization-/main/Datasets/'


total_data = pd.read_csv("total_data.csv",index_col='Unnamed: 0')
vegetal_data = pd.read_csv("vegetal_data.csv",index_col='Unnamed: 0')
grains_data = pd.read_csv("grains_data.csv",index_col='Unnamed: 0')
dairy_data = pd.read_csv("dairy_data.csv",index_col='Unnamed: 0')
meat_data = pd.read_csv("meat_data.csv",index_col='Unnamed: 0')
seafood_data = pd.read_csv("seafood_data.csv",index_col='Unnamed: 0')
oils_data = pd.read_csv("oils_data.csv",index_col='Unnamed: 0')
fish_data = pd.read_csv("fish_data.csv",index_col='Unnamed: 0')
fruits_data = pd.read_csv("fruits_data.csv",index_col='Unnamed: 0')

##################################### Show Dataset ##################################################
def dataset_of_choice(choice):
    if choice =='Vegetables':
        dataset = vegetal_data
    elif choice =='Fruits':
        dataset = fruits_data
    elif choice =='Total':
        dataset = total_data
    elif choice =='Fish':
        dataset = fish_data
    elif choice =='Oils and Fat':
        dataset = oils_data
    elif choice =='Seafood':
        dataset = seafood_data
    elif choice =='Meat':
        dataset = meat_data            
    elif choice =='Dairy':
        dataset = dairy_data
    else:
        dataset = grains_data 
    return (dataset)
###################################### Show N.V #######################################################
def nv_of_choice(choice):
    if choice =='Total Fat':
        column = 'total_fat'
    elif choice =='Fiber':
        column = 'fiber'
    elif choice =='Protein':
        column = 'protein'
    elif choice =='Sugar':
        column = 'sugars'
    else:
        column = 'carbohydrate'
    return (column)
##################################### Sunburst Plot ##############################################################################
vegetal_list = total_data.loc[total_data['Category']=='Vegetables'].index.to_list()
vegetal_list.append('Vegetables')
fruits_list = total_data.loc[total_data['Category']=='Fruits'].index.to_list()
fruits_list.append('Fruits')
grains_list = total_data.loc[total_data['Category']=='Grain'].index.to_list()
grains_list.append('Grains')
dairy_list = total_data.loc[total_data['Category']=='Dairy'].index.to_list()
dairy_list.append('Dairy')
oils_list = total_data.loc[total_data['Category']=='Oils and Fat'].index.to_list()
oils_list.append('Oils and Fat')
meat_list = total_data.loc[total_data['Category']=='Meat'].index.to_list()
meat_list.append('Meat')
fish_list = total_data.loc[total_data['Category']=='Fish'].index.to_list()
fish_list.append('Fish')
seafood_list = total_data.loc[total_data['Category']=='Seafood'].index.to_list()
seafood_list.append('Seafood')



labels = np.append(total_data['Category'].unique(), total_data.index.values)

parents = np.append([ '' for _ in range(len(total_data['Category'].unique()))], total_data['Category'].values)

colors = []
for p in labels:
    if p in vegetal_list:
        colors.append("rgba(139,85,55,255)")
    elif p in fruits_list:
        colors.append("rgba(159,105,75,255)")
    elif p in fish_list:
        colors.append("rgba(178,124,92,255)")
    elif p in meat_list:
        colors.append("rgba(233,182,145,255)")
    elif p in dairy_list:
        colors.append("rgba(252,201,163,255)")
    elif p in oils_list:
        colors.append("rgba(196,143,108,255)")
    elif p in seafood_list:
        colors.append("rgba(216,163,126,255)")
    else:
        colors.append("#rgba(119,65,36,255)")
            
#Construction of this particular graph(Sunburst)
sunburst_data = dict(type='sunburst', 
                     labels=labels, 
                     parents=parents,
                    marker=dict(colors=colors))

sunburst_layout = dict(margin=dict(t=50, l=0, r=0, b=0))

sunburst = go.Figure(data=sunburst_data, layout=sunburst_layout)
sunburst.update_layout(title={
                            'text': '<b>Check our Database!<b>',
                            'xanchor': 'center',    
                            'yanchor': 'top'}, 
                            font=dict(family="Open Sans",size=18,color='rgb(255,255,255)'),title_x = 0.5
        )
sunburst.update_layout({
'plot_bgcolor': 'rgba(0, 0, 0, 0)',
'paper_bgcolor': 'rgba(0, 0, 0, 0)',
})


########################################################## App ########################################################################
app = dash.Dash(__name__)

server = app.server

app.layout = html.Div([
    html.Div([
     html.Div([
         html.Div([
         html.H1(children='HealthID',style = {'color':'rgb(255,255,255)','font-size': '400%','text-align':'left','margin-top':'-30px','font-family': "Berlin Sans FB"}),
         html.H1(children='Find your Healthy Identity.',style ={ 'color':'#ffa846','margin-top':'30px','font-family': "Berlin Sans FB"}), ]),
         html.Div([],className='side_bar'), 
            html.Div([
                html.Div([
                    html.Div([
                        html.Img(src=app.get_asset_url('fish.png'),style ={ 'width':'22%','float':'left','margin-top':'-3px'})
                    ]),
                    html.Div([
                        html.Img(src=app.get_asset_url('lagost.png'),style ={ 'width':'25%','margin-top':'-7px','align':'center','margin-left': '15%'})
                    ]),
                    html.Div([
                        html.Img(src=app.get_asset_url('ramen.png'),style ={ 'width':'25%','float':'right','margin-top':'-103px','margin-left':'-90x'})
                    ])
                ],className = 'boxes_images'),
                html.Div([
                    	html.P('In the fast-paced, processed food environment we are currently living, it is very important to be aware of the aliments we are ingesting. Having a sane, healthy lifestyle goes through more than exercising and having proper rest. It is important to be conscious and have a certain level of understanding regarding what we are eating. For that, HealthID was created.', 
                    style={'font-family': "verdana",'color':'rgb(255,255,255)','margin-top':'-210px', 'text-align': 'justify','width':'400px','height':'400px','margin-left':'-100px','position':'left','font-size':'17px'}),
                    html.P('For you to find your own healthy identity.', style={'font-family': "verdana",'color':'rgb(255,255,255)','margin-top':'-220px','text-align':'left','width':'400px','margin-left':'-100px','position':'left','font-size':'17px'}),
                        html.Br(),
                        html.P('To eat is a necessity, but to eat intelligently is an art. - La Rochefoucauld',
                        style={'font-family': "verdana",'font-style': 'italic','color':'#ffa846','margin-top':'-29px','text-align':'left','width':'400px','margin-left':'-100px','position':'left','font-size':'17px'}),
                        ],className = 'image_label')
                    ],className = 'image_box'),
                html.Div([
                        html.Img(src=app.get_asset_url('avocado.png'),style ={ 'width':'25%','float':'right','margin-top':'-140px','margin-right':'-90px'})
                    ]),
            html.Div([
            html.Div([   
            dcc.Graph(figure=sunburst)],style = {'align':'center','top':'-70px'},className = 'sunburst'),],className = 'box_sunburst'),
         ]),
    ],className = 'center_box'),
            html.Div([
                html.Div([
                    html.H1('Choose One Category:',style ={ 'color':'rgb(255,255,255)' ,'margin-top':'-50px','float':'left'}), 
                    ], style={'margin': '10px','align':'center'},id = 'choose'),
                    html.Br(),
                    html.Div([
                        dcc.RadioItems(id='radio',value= 'Vegetables',inline=True,style = {'align':'center','bottom':'150px'},
                        options=[{'label': x, 'value': x}
                                for x in ['Vegetables', 'Fruits','Grains','Dairy','Oils and Fat','Meat','Fish','Seafood','Total']])
                    ],style = {'align':'center'},className = 'radio'),
                    ],className = 'box_categorie'),
            html.Div([
                html.H2('Did you know that?',style ={ 'color':'#ffa846','margin-top':'-50px' }),
                html.Div([
                html.P(style ={ 'color':'rgb(255,255,255)' },id = 'fun_fact')]),
                ],className = 'facts_2'),
                html.Br(),
                html.Br(),
             html.Div([
                        html.P(style ={ 'color':'rgb(255,255,255)','margin-top':'-50px'},id = 'user_choice')],className = 'facts'),
            html.Div([
                  html.Div([
                            html.H2('Choose the aliment you want!',style ={ 'color':'rgb(255,255,255)' }),
                            html.Div([
                                dcc.Dropdown(id='drop'),
                            ],style = {'align':'center'},className ='choice1'),
                                                    html.Div([
                            dcc.Graph(id= 'calorie')],className = 'calorie_box'),
                            html.Div([
                            dcc.Graph(style = {'align':'center'},id= 'graph')
                        ],className = 'aliment'),
                            ],className = 'second_box'),
    html.Div([
          html.H2('Let us see the top 10 aliments by nutrition value!',style ={ 'color':'rgba(249,193,120,255)' }),
          html.Div([
                        html.Img(src=app.get_asset_url('carrots_imag.png'),style ={ 'width':'25%','float':'left','margin-top':'-123.5px','margin-left':'-54px'})
                    ]),
             html.Div([
            dcc.Dropdown(  options=[{'label': x, 'value': x}
                 for x in ['Total Fat', 'Fiber','Protein','CarboHydrate','Sugar']],value='Total Fat',id='drop2'),
            ],className ='choice2'),
            html.Div([
                dcc.Graph(id = 'nv_image',style = {'margin-left':'350px'})
            ]),
            html.Div([
            dcc.Graph(id= 'top10')],className = 'top10'),
           ],className = 'third_box'),
           ],className = 'center_box'),
        html.Br(), 
        html.Br(),
        html.Div([
        html.H1(children=' Let us compare two different aliments!',style ={'color':'rgb(255,255,255)','margin-left':'260px' }),
        html.H2('First, you must choose the categories!',style ={ 'color':'rgb(255,255,255)','margin-left':'350px'}),
        html.Div([
            html.Div([
                html.Div([
                    dcc.Dropdown(['Vegetables', 'Fruits','Grains','Dairy','Oils and Fat','Meat','Fish','Seafood'], 'Vegetables', id='drop_category_1'),
                    ],className = 'choice3'),
                    html.Br(), 
                    html.Br(),
                html.Div([
                    dcc.Dropdown(id='drop3')],className = 'choice3'),
                  html.Div([  
                        dcc.Graph(id= 'calorie_2')],className = 'calorie_box_2'),
                    ],className = 'box_4'),
                html.Div([],className = 'image_pan'),
            html.Div([
                html.Div([
                    dcc.Dropdown(['Vegetables', 'Fruits','Grains','Dairy','Oils and Fat','Meat','Fish','Seafood'], 'Vegetables', id='drop_category_2'),
                    ],className = 'choice4'),
                    html.Br(), 
                    html.Br(),
            html.Div([
                dcc.Dropdown(id='drop4',style = {'align':'right'})],className = 'choice4'),
                  html.Div([  
                        dcc.Graph(id= 'calorie_3')],className = 'calorie_box_3'),
                ],className = 'box_5'),
            ],className = 'center_box'),
            html.Div([
        dcc.Graph(id= 'radar',style = {'align':'right'}) 
        ],className = 'last_graph'),     
    ],className = 'last_box'),
    html.Br(),
    html.Br(),
    html.Div([
                    html.P('Ana Portugal, Carolina Machado, Francisco Calha, Sara Arana', style={'font-size':'12px'}),
                        html.P(['Source:', html.A('Nutritional values for common foods and products', href='https://www.kaggle.com/datasets/trolukovich/nutritional-values-for-common-foods-and-products', target='_blank')], style={'font-size':'12px'})
                ], className = 'box_footer')
])


#######################################Callback #######################################
@app.callback(
    [Output('drop', 'options'),
     Output('drop', 'value')],
    Input('radio', 'value'))

def dropdown_options(radio_value):
    if radio_value == 'Vegetables':
        list_aliments = total_data.loc[total_data['Category']== 'Vegetables'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = vegetal_list[0]
    elif radio_value == 'Fruits':
        list_aliments = total_data.loc[total_data['Category']== 'Fruits'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = fruits_list[0]
    elif radio_value == 'Dairy':
        list_aliments = total_data.loc[total_data['Category']== 'Dairy'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = dairy_list[0]

    elif radio_value == 'Oils and Fat':
        list_aliments = total_data.loc[total_data['Category']== 'Oils and Fat'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = oils_list[0]
    elif radio_value == 'Meat':
        list_aliments = total_data.loc[total_data['Category']== 'Meat'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = meat_list[0]
    elif radio_value == 'Fish':
        list_aliments = total_data.loc[total_data['Category']== 'Fish'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = fish_list[0]
    elif radio_value == 'Seafood':
        list_aliments = total_data.loc[total_data['Category']== 'Seafood'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = seafood_list[0]
    elif radio_value == 'Total':
        list_aliments = total_data.index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = list_aliments[0]
    else:
        list_aliments = total_data.loc[total_data['Category']== 'Grain'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = grains_list[0]
    return options,value

@app.callback(
    Output('user_choice', 'children'),
    [Input('radio', 'value')])
 
def fact(radio_value):
    if radio_value == 'Vegetables':
        fact = "You chose Vegetables as your category!"
    elif radio_value == 'Fruits':
        fact = "You chose Fruits as your category!"
    elif radio_value == 'Dairy':
        fact = "You chose Dairy as your category!"
    elif radio_value == 'Oils and Fat':
        fact = 'You chose Oils and Fat as your category!'
    elif radio_value == 'Meat':
        fact = "You chose Meat as your category!"
    elif radio_value == 'Fish':
        fact = "You chose Fish as your category! "
    elif radio_value == 'Seafood':
        fact = "You chose Seafood as your category!"
    elif radio_value == 'Total':
        fact = "You chose Total as your category!"
    else:
        fact = "You chose Grains as your category!"
    return fact
@app.callback(
    Output('fun_fact', 'children'),
    [Input('radio', 'value')])
 
def fun_fact(radio_value):
    if radio_value == 'Vegetables':
        fact = "Vegetables can lower eye and digestive problems and improve your blood pressure."
    elif radio_value == 'Fruits':
        fact = "Fruits help reduce the risk of diabetes, obesity, stroke, heart disease, and cancer."
    elif radio_value == 'Dairy':
        fact = "Drinking milk and dairy products may prevent osteoporosis and bone fractures and even help you maintain a healthy weight."
    elif radio_value == 'Oils and Fat':
        fact = 'Oils and Fats are a source of energy for the body, also they insulate and protect the body vital organs.'
    elif radio_value == 'Meat':
        fact = "Meat is an excellent source of protein, which helps build and repair muscle as well as helping maintaining healthy hair, bones, skin and blood."
    elif radio_value == 'Fish':
        fact = "Fish have essential nutrients to keep our heart and brain healthy."
    elif radio_value == 'Seafood':
        fact = "Seafood is full of nutrients that are essential in maintaining your health, in particularly, your brain, eyes, and immune system."
    elif radio_value == 'Total':
        fact = "Eating healthy may help you live longer, prevent some diseases and helps achieve and maintain a healthy weight."
    else:
        fact = "Grains can reduce your risk of obesity,stroke and heart disease and reduce chronic inflammation."
    return fact

@app.callback(
    Output('graph', 'figure'),
    [Input('drop', 'value')])

def plot_aliment(drop_value):
    dataset_2 = total_data[['total_fat', 'fiber', 'protein', 'carbohydrate', 'sugars']].loc[total_data.index == drop_value]
    series1=dataset_2.transpose().iloc[:,0].sort_values(ascending = True)

    x_bar = series1
    y_bar = series1.index

    data = dict(type='bar', x=x_bar, y=y_bar, orientation = 'h')
    layout = dict(xaxis=dict(title='For each 100g'))

    fig = go.Figure(data=data, layout=layout)
    fig.update_traces(marker_color="#fddcc3")
    fig.update_layout({
        'plot_bgcolor': 'rgba(0, 0, 0, 0)',
        'paper_bgcolor': 'rgba(0, 0, 0, 0)',
                })
    return(fig)
@app.callback(
    Output('calorie', 'figure'),
    [Input('drop', 'value')])
def max_calories(drop_value):
    dataset = total_data
    aliment = drop_value
    max_calories = max(dataset['calories'].to_list())
    calories_aliment = dataset.loc[aliment]['calories']
    labels = ['Non Calories','Calories']
    values = [max_calories, calories_aliment]

    # Use `hole` to create a donut-like pie chart
    fig = go.Figure(data=[go.Pie(labels=labels, values=values, hole=.6, title = str(calories_aliment)+' kcal')])
    fig.update_traces(hoverinfo='label+percent', textinfo='none')
    fig.update(layout_showlegend=False)
    fig.update_layout(font=dict(size=20))
    fig.update_traces(marker=dict(colors=['#fddcc3', '#d58923']))
    fig.update_layout({
        'plot_bgcolor': 'rgba(0, 0, 0, 0)',
        'paper_bgcolor': 'rgba(0, 0, 0, 0)',})
    return(fig)

@app.callback(
    Output('nv_image', 'figure'),
    [Input('drop2', 'value')])

def image(drop2_value): 
    fig = go.Figure()

    img_width = 200
    img_height = 200
    scale_factor = 0.5

    fig.add_trace(
        go.Scatter(
            x=[0, img_width * scale_factor],
            y=[0, img_height * scale_factor],
            mode="markers",
            marker_opacity=0
        )
    )

      
    fig.update_xaxes(
            visible=False,
            range=[0, img_width * scale_factor]
        )

    fig.update_yaxes(
        visible=False,
        range=[0, img_height * scale_factor],
        scaleanchor="x"
    )

    fig.update_layout(
            width=img_width * scale_factor,
            height=img_height * scale_factor,
            margin={"l": 0, "r": 0, "t": 0, "b": 0},
        )
    
    if drop2_value == 'Total Fat':
        fig.add_layout_image(
            dict(
                x=0,
                sizex=img_width * scale_factor,
                y=img_height * scale_factor,
                sizey=img_height * scale_factor,
                xref="x",
                yref="y",
                opacity=1.0,
                layer="below",
                sizing="stretch",
                source= app.get_asset_url('fat.jpg')))
    elif drop2_value == 'Fiber':
        fig.add_layout_image(
            dict(
                x=0,
                sizex=img_width * scale_factor,
                y=img_height * scale_factor,
                sizey=img_height * scale_factor,
                xref="x",
                yref="y",
                opacity=1.0,
                layer="below",
                sizing="stretch",
                source= app.get_asset_url('fiber.jpg'))) 
    elif drop2_value == 'Protein':
        fig.add_layout_image(
            dict(
                x=0,
                sizex=img_width * scale_factor,
                y=img_height * scale_factor,
                sizey=img_height * scale_factor,
                xref="x",
                yref="y",
                opacity=1.0,
                layer="below",
                sizing="stretch",
                source= app.get_asset_url('protein.jpg')))  
    elif drop2_value == 'Sugar':
        fig.add_layout_image(
            dict(
                x=0,
                sizex=img_width * scale_factor,
                y=img_height * scale_factor,
                sizey=img_height * scale_factor,
                xref="x",
                yref="y",
                opacity=1.0,
                layer="below",
                sizing="stretch",
                source= app.get_asset_url('sugar.jpg')))
    else:
        fig.add_layout_image(
            dict(
                x=0,
                sizex=img_width * scale_factor,
                y=img_height * scale_factor,
                sizey=img_height * scale_factor,
                xref="x",
                yref="y",
                opacity=1.0,
                layer="below",
                sizing="stretch",
                source= app.get_asset_url('carbo.jpg')))   
    return(fig)            
@app.callback(
    Output('top10', 'figure'),
    [Input('radio', 'value'),Input('drop2', 'value')])

def top_10(radio_value,drop2_value):
    data = dataset_of_choice(radio_value)
    nv = nv_of_choice(drop2_value)
    dataset = data[nv].sort_values(ascending = False)[:9]
    dataset

    x_bar = dataset.index
    y_bar = dataset   

    data = dict(type='bar', x=x_bar, y=y_bar)
    

    fig = go.Figure(data=data)
    fig.update_traces(marker_color="#d58923")
    fig.update_layout({
        'plot_bgcolor': 'rgba(0, 0, 0, 0)',
        'paper_bgcolor': 'rgba(0, 0, 0, 0)',})
    return(fig)

@app.callback(
   [Output('drop3', 'options'),
     Output('drop3', 'value')],
    Input('drop_category_1', 'value'))

def dropdown_options(drop_category_1):
    if drop_category_1 == 'Vegetables':
        list_aliments = total_data.loc[total_data['Category']== 'Vegetables'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = vegetal_list[0]
    elif drop_category_1 == 'Fruits':
        list_aliments = total_data.loc[total_data['Category']== 'Fruits'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = fruits_list[0]
    elif drop_category_1 == 'Dairy':
        list_aliments = total_data.loc[total_data['Category']== 'Dairy'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = dairy_list[0]

    elif drop_category_1 == 'Oils and Fat':
        list_aliments = total_data.loc[total_data['Category']== 'Oils and Fat'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = oils_list[0]
    elif drop_category_1 == 'Meat':
        list_aliments = total_data.loc[total_data['Category']== 'Meat'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = meat_list[0]
    elif drop_category_1 == 'Fish':
        list_aliments = total_data.loc[total_data['Category']== 'Fish'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = fish_list[0]
    elif drop_category_1 == 'Seafood':
        list_aliments = total_data.loc[total_data['Category']== 'Seafood'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = seafood_list[0]
    else:
        list_aliments = total_data.loc[total_data['Category']== 'Grain'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = grains_list[0]
    return options, value

@app.callback(
    Output('calorie_2', 'figure'),
    [Input('drop3', 'value')])

def max_calories(drop3_value):
    aliment = drop3_value
    max_calories = max(total_data['calories'].to_list())
    calories_aliment = total_data.loc[aliment]['calories']
    labels = ['Non Calories','Calories']
    values = [max_calories, calories_aliment]
        # Use `hole` to create a donut-like pie chart
    fig = go.Figure(data=[go.Pie(labels=labels, values=values, hole=.6, title = str(calories_aliment)+' kcal')])
    fig.update_traces(hoverinfo='label+percent', textinfo='none')
    fig.update(layout_showlegend=False)
    fig.update_layout(font=dict(size=20))     
    fig.update_traces(marker=dict(colors=['#d58923 ', 'rgb(255,255,255)']))
    fig.update_layout({
        'plot_bgcolor': 'rgba(0, 0, 0, 0)',
        'paper_bgcolor': 'rgba(0, 0, 0, 0)',})
    return(fig)

@app.callback(
   [Output('drop4', 'options'),
     Output('drop4', 'value')],
    Input('drop_category_2', 'value'))

def dropdown_options(drop_category_2):
    if drop_category_2 == 'Vegetables':
        list_aliments = total_data.loc[total_data['Category']== 'Vegetables'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = vegetal_list[0]
    elif drop_category_2 == 'Fruits':
        list_aliments = total_data.loc[total_data['Category']== 'Fruits'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = fruits_list[0]
    elif drop_category_2 == 'Dairy':
        list_aliments = total_data.loc[total_data['Category']== 'Dairy'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = dairy_list[0]

    elif drop_category_2 == 'Oils and Fat':
        list_aliments = total_data.loc[total_data['Category']== 'Oils and Fat'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = oils_list[0]
    elif drop_category_2 == 'Meat':
        list_aliments = total_data.loc[total_data['Category']== 'Meat'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = meat_list[0]
    elif drop_category_2 == 'Fish':
        list_aliments = total_data.loc[total_data['Category']== 'Fish'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = fish_list[0]
    elif drop_category_2 == 'Seafood':
        list_aliments = total_data.loc[total_data['Category']== 'Seafood'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = seafood_list[0]
    else:
        list_aliments = total_data.loc[total_data['Category']== 'Grain'].index.to_list()
        options = []
        for al in list_aliments:
            options.append({'label': al,'value': al})
        value = grains_list[0]
    return options, value
@app.callback(
    Output('calorie_3', 'figure'),
    [Input('drop4', 'value')])
def max_calories(drop4_value):
    dataset = total_data
    aliment = drop4_value
    max_calories = max(dataset['calories'].to_list())
    calories_aliment = dataset.loc[aliment]['calories']
    labels = ['Non Calories','Calories']
    values = [max_calories, calories_aliment]
        # Use `hole` to create a donut-like pie chart
    fig = go.Figure(data=[go.Pie(labels=labels, values=values, hole=.6, title = str(calories_aliment)+' kcal')])
    fig.update_traces(hoverinfo='label+percent', textinfo='none')
    fig.update(layout_showlegend=False) 
    fig.update_layout(font=dict(size=20))  
    fig.update_traces(marker=dict(colors=['#fddcc3', 'rgb(255,255,255)']))
    fig.update_layout({
        'plot_bgcolor': 'rgba(0, 0, 0, 0)',     
        'paper_bgcolor': 'rgba(0, 0, 0, 0)',})
    return(fig)

@app.callback(
    Output('radar', 'figure'),
    [Input('drop3', 'value'),
    Input('drop4', 'value')])
    
def compare(drop3_value,drop4_value):

    dataset_2 = total_data[['total_fat', 'fiber', 'protein', 'carbohydrate', 'sugars']].loc[total_data.index == drop3_value]
    series1=dataset_2.transpose().iloc[:,0].sort_values(ascending = True)
    series1

    dataset_2 = total_data[['total_fat', 'fiber', 'protein', 'carbohydrate', 'sugars']].loc[total_data.index == drop4_value]
    series2=dataset_2.transpose().iloc[:,0].sort_values(ascending = True)
    series2

    fig = go.Figure(data=[
        go.Bar(y=series1.index, x=series1, orientation='h', name=drop3_value, base=0,marker={'color':'#fddcc3'}),
        go.Bar(y=series2.index, x=-series2, orientation='h', name=drop4_value, base=0,marker={'color':'#d58923'})
    ])

    fig.update_layout(
        barmode='stack',
        title={'text': drop3_value +' ' + 'vs' + ' '+ drop4_value,
              'x':0.5,
              'xanchor': 'center'
        })

    fig.update_yaxes(
            ticktext=['aa', 'bb', 'cc', 'dd']
        )
    fig.update_layout({
        'plot_bgcolor': 'rgba(0, 0, 0, 0)',
        'paper_bgcolor': 'rgba(0, 0, 0, 0)',
                })
    fig.update_layout(
    font_color='rgb(255,255,255)',
    title_font_color='rgb(255,255,255)',
    legend_title_font_color= 'rgb(255,255,255)',
)
    return(fig)


if __name__ == '__main__':
    app.run_server(debug=True)

