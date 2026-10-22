from di.container import Container
from web.module.game_module import create_app

container = Container()
app = create_app(container.service)
print("\n=== ДОСТУПНЫЕ КОМАНДЫ ===")
for rule in app.url_map.iter_rules():
    methods = ', '.join(sorted(rule.methods - {'HEAD', 'OPTIONS'}))
    print(f"{methods:15} -> {rule.rule}")
print("============================\n")
if __name__ == "__main__":
    app.run(debug=True)
