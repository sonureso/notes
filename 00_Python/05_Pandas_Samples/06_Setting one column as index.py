import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import style
style.use("fivethirtyeight")

data = {"Day":[1,2,3,4],"Visitors":[100,255,211,131],"Bounce_Rate":[25,11,18,9]}
df = pd.DataFrame(data)
df.set_index("Day", inplace=True)
print(df)

df.plot()
plt.show()
