class_name AIFileAccess
extends RefCounted

var schemas: AISchemas = AISchemas.new()

func save_file(entity: AIEntity, file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(serialize_entity(entity))
	
func file_exists(file_path: String) -> bool:
	return FileAccess.file_exists(file_path)

func load_file(file_path: String) -> AIEntity:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	return deserialize_entity(content)

func serialize_entity(entity: AIEntity) -> String:
	var entity_as_dict: Dictionary = schemas.AIEntitySchema.to_dict(entity)
	return JSON.stringify(entity_as_dict, "  ")

func deserialize_entity(content: String) -> AIEntity:
	var entity_as_dict: Dictionary = JSON.parse_string(content)
	return schemas.AIEntitySchema.to_domain(entity_as_dict)
