f= open('mas.txt', 'r+', encoding="utf-8")
esp=''
ing=''
i=0
lines=f.readlines()
flag= True



w = open("mas BD adjetivos.txt","w",encoding="utf-8")

while flag:
    if i==121:
        break
    #elif i == 5:
 #       break
    elif i%2==0:
        ing=lines[i]
    else:
        esp=lines[i]
        w.write("\n")
        w.write("traduccion('"+esp+"','"+ing+"').")
    i+=1

w.close()
