import json

text_list = input("Введите название файла(пример input.txt): ")

try:
    with open(text_list, 'r', encoding='utf-8') as f:
        content = f.read().strip()
        if not content:
            print("Empty file!")
            exit()
        data = json.loads(content)
        if not isinstance(data, dict) or 'list1' not in data or 'list2' not in data:
            print("Incorrect json")
            exit()
        if not isinstance(data['list1'], list) or not isinstance(data['list2'], list):
            print("Incorrect json")
            exit()
        list1 = data['list1']
        list2 = data['list2']
        merged_list = list1 + list2
        for i in range(len(merged_list)):
            for j in range(i + 1, len(merged_list)):
                if merged_list[j]["year"] < merged_list[i]["year"]:
                    merged_list[i], merged_list[j] = merged_list[j], merged_list[i]
        print(json.dumps(merged_list, indent=2, ensure_ascii=False))
except FileNotFoundError:
    print("File not found!")
except json.JSONDecodeError:
    print("Incorrect json")