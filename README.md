# Gestão de Desastres
Estrutura do banco de dados do sistema de gestão de desastres, desenvolvido durante a participação da Latromi no Gabinete de Crise do Governo do Estado do RS — Comitê de Transporte e Logística

## Tabelas

<details>
<summary>countries — Cadastro de Países</summary>

### Tabela `countries`

Cadastro de Países

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| country_id 🔑 | `integer` | Não | Identificador do país |
| name | `text` | Não | Nome do país |
| alpha2 | `character varying(2)` | Não | Sigla de 2 caracteres do país |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_country_id | country_id |  |
| `UNIQUE` | uk_country_alpha2 | alpha2 |  |
</details>
<details>
<summary>states — Cadastro de Estados</summary>

### Tabela `states`

Cadastro de Estados

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| state_id 🔑 | `integer` | Não | Identificador do estado |
| country_id | `integer` | Não | Identificador do país |
| name | `text` | Não | Nome do estado |
| alpha2 | `character varying(2)` | Não | Sigla de 2 catacteres do estado |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_state_id | state_id |  |
| `UNIQUE` | uk_state_countryid_alpha2 | country_id, alpha2 |  |
| `FOREIGN KEY` | fk_state_countryid | country_id | countries (country_id) |
</details>
<details>
<summary>cities — Cadastro de cidade</summary>

### Tabela `cities`

Cadastro de cidade

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| city_id 🔑 | `integer` | Não | Identificador da cidade |
| name | `text` | Não | Nome da cidade |
| normalized_name | `text` | Não | Nome normalizado da cidade |
| state_id | `integer` | Não | Identificador do estado |
| cod_ibge | `integer` | Sim | Código do IBGE da cidade |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_cities_id | city_id |  |
| `FOREIGN KEY` | fk_cities_id | state_id | states (state_id) |
</details>
<details>
<summary>binaries — Tabela onde são armazenados os arquivos binários (blobs), como fotos por exemplo.</summary>

### Tabela `binaries`

Tabela onde são armazenados os arquivos binários (blobs), como fotos por exemplo.

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| binary_id 🔑 | `uuid` | Não | Identificador do binário (UUID) |
| binary_hash | `character varying(64)` | Não | HASH SHA256 do binário |
| size | `integer` | Não | Tamanho do binário em bytes |
| mime_type | `text` | Sim |  |
| content | `bytea` | Sim | Conteúdo do binário (array de bytes) |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_binaries_id | binary_id |  |
| `UNIQUE` | fk_binaries_hash | binary_hash |  |
</details>
<details>
<summary>files — Armazena a referência aos arquivos. Quando a coluna "binary_hash" estiver preenchida, significa que o arquivo foi salvo no banco de dados. Neste caso, o conteúdo dele está gravado na tabela "storage.binaries".</summary>

### Tabela `files`

Armazena a referência aos arquivos. Quando a coluna "binary_hash" estiver preenchida, significa que o arquivo foi salvo no banco de dados. Neste caso, o conteúdo dele está gravado na tabela "storage.binaries".

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| file_id 🔑 | `uuid` | Não | Identificador do Arquivo (UUID) |
| file_name | `text` | Sim |  |
| binary_id | `uuid` | Sim | Referência do binário (FK com a tabela "binaries") |
| mime_type | `text` | Sim | Tipo de conteúdo do arquivo. Exemplo: "text/plain", "text/html", "image/jpeg" |
| external_url | `text` | Sim | URL externa do arquivo. Quando essa URL for informada, significa que o arquivo está armazenado em outro local que não seja o banco de dados. |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do arquivo |
| updated_at | `timestamp with time zone` | Sim | Data e hora de atualização do arquivo |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_files_fileid | file_id |  |
| `FOREIGN KEY` | fk_files_binaryid | binary_id | binaries (binary_id) |
</details>
<details>
<summary>address_sets — Conjunto de endereços. Por exemplo, uma pessoa pode ter mais de um endereço cadastrado (Casa, Escritório). Os endereços são agrupados no conjunto de endereços e o ID do conjunto é assoaciado ao cadastro da pessoa</summary>

### Tabela `address_sets`

Conjunto de endereços. Por exemplo, uma pessoa pode ter mais de um endereço cadastrado (Casa, Escritório). Os endereços são agrupados no conjunto de endereços e o ID do conjunto é assoaciado ao cadastro da pessoa

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| address_set_id 🔑 | `uuid` | Não | Identificador do conjunto de endereços (UUID) |
| name | `text` | Sim | Nome do conjunto de endereços. |
| main_address_id | `uuid` | Sim | Referência do endereço principal, dentre os endereços que fazem parte do conjunto. |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do conjunto de endereços. |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_addresssets_id | address_set_id |  |
</details>
<details>
<summary>addresses — Endereços cadastrados. Os endereços podem ser cadastrados a vulso ou associados a um conjunto de endereços.</summary>

### Tabela `addresses`

Endereços cadastrados. Os endereços podem ser cadastrados a vulso ou associados a um conjunto de endereços.

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| address_id 🔑 | `uuid` | Não | Identificador do endereços (UUID) |
| name | `text` | Sim | Nome do endereço. Exemplo: Escritório, Depósito, CD-01 |
| state_id | `integer` | Não | Referência do Estado/UF (FK com a tabela "states"). |
| city_id | `integer` | Não | Referência da Cidade (FK com a tabela "cities"). |
| city_name | `text` | Sim | Campo para preenchimento livre do nome da cidade, nos casos onde a cidade não esteja cadastrada. |
| cep | `text` | Sim | Código de endereço postal |
| district | `text` | Sim | Nome do Bairro |
| address | `text` | Não | Descrição da Rua/Logradouro/Avenida (sem número) |
| address_number | `integer` | Sim | Número do endereço. Se não existir, informar NULL |
| address_complement | `text` | Sim | Complemento de endereço. Exemplo (Bloco A, Apto 123) |
| address_set_id | `uuid` | Sim | Referência do conjunto de endereços (FK com a tabela "address_sets"); |
| created_at | `timestamp with time zone` | Não |  |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_address_id | address_id |  |
| `FOREIGN KEY` | fk_address_addrsetid | address_set_id | address_sets (address_set_id) |
| `FOREIGN KEY` | fk_address_cityid | city_id | cities (city_id) |
| `FOREIGN KEY` | fk_address_stateid | state_id | states (state_id) |
</details>
<details>
<summary>organizations — Cadastro de organizações/empresas</summary>

### Tabela `organizations`

Cadastro de organizações/empresas

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| organization_id 🔑 | `integer` | Não |  |
| cnpj | `character varying(14)` | Sim | CNPJ da organização |
| name | `text` | Não | Nome da organização |
| state_id | `integer` | Sim | [Obsoleto] Referência do estado/UF (FK com a tabela "states"). Este campo só é preenchido pela tela de doações do Callcenter |
| city_id | `integer` | Sim | [Obsoleto] Referência da cidade (FK com a tabela "cities"). Este campo só é preenchido pela tela de doações do Callcenter |
| city_name | `text` | Sim | [Obsoleto] Campo para preenchimento livre do nome da cidade, nos casos onde a cidade não esteja cadastrada. Este campo só é preenchido pela tela de doações do Callcenter |
| cep | `character varying(8)` | Sim | [Obsoleto] Código de Endereço Postal. Este campo só é preenchido pela tela de doações do Callcenter |
| district | `text` | Sim | [Obsoleto] Nome do bairro. Este campo só é preenchido pela tela de doações do Callcenter |
| address | `text` | Sim | [Obsoleto] Descrição da Rua/Logradouro/Avenida (sem número). Este campo só é preenchido pela tela de doações do Callcenter |
| address_number | `integer` | Sim | [Obsoleto] Número do endereço. Se não existir, informar NULL. Este campo só é preenchido pela tela de doações do Callcenter |
| address_complement | `text` | Sim | [Obsoleto] Complemento de endereço. Exemplo (Bloco A, Apto 123). Este campo só é preenchido pela tela de doações do Callcenter |
| coordinates | `point` | Sim | [Obsoleto] Coordenadas do endereço |
| address_set_id | `uuid` | Sim | Referência do conjunto de endereços (FK com a tabela "address_sets") |
| main_contact_name | `text` | Sim | Nome do contato principal |
| main_contact_phone | `text` | Sim | Telefone do contato principal |
| main_contact_email | `text` | Sim | E-mail do contato principal |
| alt_contact_name | `text` | Sim | Nome do contato alternativo |
| alt_contact_phone | `text` | Sim | Telefone do contato alternativo |
| alt_contact_email | `text` | Sim | E-mail do contato alternativo |
| notes | `text` | Sim | Observações gerais sobre a organização |
| status | `character(1)` | Não | Situação do cadastro: T-temporario, C-Criado |
| created_at | `timestamp with time zone` | Não | Data e hora do registro da organização |
| updated_at | `timestamp with time zone` | Sim | Data e hora de alteração da organização |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_organizations_id | organization_id |  |
| `UNIQUE` | uk_organizations_cnpj | cnpj |  |
| `FOREIGN KEY` | fk_organizations_addrsetid | address_set_id | address_sets (address_set_id) |
| `FOREIGN KEY` | fk_organizations_cityid | city_id | cities (city_id) |
</details>
<details>
<summary>persons — Cadastro de Pessoas</summary>

### Tabela `persons`

Cadastro de Pessoas

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| person_id 🔑 | `integer` | Não | Identificador da pessoa cadastrada |
| cpf | `character varying(11)` | Sim | Número do CPF (sem separadores) |
| name | `text` | Sim | Nome completo da pessoa |
| phone1_name | `text` | Sim | Identificação do telefone principal. Exemplo: Celular, Comercial |
| phone1_number | `text` | Sim | Número do telefone principal (com DDD, sem formatação) |
| phone2_name | `text` | Sim | Identificação do telefone alternativo. Exemplo: Celular, Comercial |
| phone2_number | `text` | Sim | Número do telefone alternativo (com DDD, sem formatação) |
| email | `text` | Sim | Endereço de e-mail |
| notes | `text` | Sim | Observações sobre a pessoa |
| address_set_id | `uuid` | Sim | ID do endereço da pessoa |
| status | `character(1)` | Não | Situação do cadastro: T-Temporary, C-Created |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro |
| updated_at | `timestamp with time zone` | Sim | Data e hora em que o registro foi atualizado pela última vez |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_person_id | person_id |  |
| `UNIQUE` | uk_person_cpf | cpf |  |
| `FOREIGN KEY` | fk_persons_addrsetid | address_set_id | address_sets (address_set_id) |
</details>
<details>
<summary>users — Cadastros dos usuários</summary>

### Tabela `users`

Cadastros dos usuários

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| user_id 🔑 | `uuid` | Não | Identificador do usuário |
| username | `text` | Não | Nome de usuário |
| password | `text` | Sim | Senha do usuário |
| person_id | `integer` | Sim | Identificador da pessoa associada ao usuário |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi criado |
| updated_at | `timestamp with time zone` | Sim |  |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_users_id | user_id |  |
| `UNIQUE` | uk_users_username | username |  |
| `FOREIGN KEY` | fk_users_person_id | person_id | persons (person_id) |
</details>
<details>
<summary>entities — Cadastro de entidades. Uma entidade é uma organização lógica, não necessáriamente vinculada à um CNPJ. Exemplo: Regionais da Defesa Civil, ONG, abrigos, orgão governamentais.</summary>

### Tabela `entities`

Cadastro de entidades. Uma entidade é uma organização lógica, não necessáriamente vinculada à um CNPJ. Exemplo: Regionais da Defesa Civil, ONG, abrigos, orgão governamentais.

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| entity_id 🔑 | `uuid` | Não | Identificador da entidade |
| name | `text` | Sim | Nome da entidade |
| parent_entity_id | `uuid` | Sim | Identificador da entidade superior |
| level | `integer` | Não | Nível hierarquico da entidade em relação aos níveis superiores, sendo 0 (zero) o mais elevado (ordem decrescente). |
| organization_id | `integer` | Sim | Identificador da organização vinculada à entidade. |
| address_set_id | `uuid` | Sim | Identificador do conjunto de endereços |
| enabled | `boolean` | Não | Se true, indica que a entidade está habilitada. |
| callcenter | `boolean` | Não | Se true, indica que a entidade é um callcenter. Neste caso, existem alguns comportamentos diferenciados na rotina de registro de doações/ofertas. |
| delivery_address_set_id | `uuid` | Sim | Identificador do conjunto de endereços de entrega. |
| default_user_group_name | `text` | Sim | Nome do grupo de usuário padrão da entidade. |
| created_at | `timestamp with time zone` | Sim | Data e hora de criação do registro. |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última vez que o registro foi atualizado. |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_entities_id | entity_id |  |
| `FOREIGN KEY` | fk_entities_addrsetid | address_set_id | address_sets (address_set_id) |
| `FOREIGN KEY` | fk_entities_deliveryaddrsetid | delivery_address_set_id | address_sets (address_set_id) |
| `FOREIGN KEY` | fk_entities_organizationid | organization_id | organizations (organization_id) |
| `FOREIGN KEY` | fk_entities_parententityid | parent_entity_id | entities (entity_id) |
</details>
<details>
<summary>entities_users — Usuários que fazem parte de uma entidade</summary>

### Tabela `entities_users`

Usuários que fazem parte de uma entidade

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| entity_id 🔑 | `uuid` | Não | Identificador da entidade |
| user_id 🔑 | `uuid` | Não | Identificador do usuário |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_entitiesusers_entityid | entity_id, user_id |  |
| `UNIQUE` | uk_entitiesusers_userid | user_id |  |
| `FOREIGN KEY` | fk_entitiesusers_entityid | entity_id | entities (entity_id) |
| `FOREIGN KEY` | fk_entitiesusers_userid | user_id | users (user_id) |
</details>
<details>
<summary>entities_addresses — [Obsoleto: Essa tabela foi descontinuada, e no lugar dela, passamos a utilizar "address_sets"] Conjunto de endereços da entidade.</summary>

### Tabela `entities_addresses`

[Obsoleto: Essa tabela foi descontinuada, e no lugar dela, passamos a utilizar "address_sets"] Conjunto de endereços da entidade.

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| entity_id 🔑 | `uuid` | Não |  |
| address_id 🔑 | `uuid` | Não |  |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_entitiesaddress_enityid_addressid | entity_id, address_id |  |
| `FOREIGN KEY` | fk_entitiesaddress_addressid | address_id | addresses (address_id) |
| `FOREIGN KEY` | fk_entitiesaddress_enityid | entity_id | entities (entity_id) |
</details>
<details>
<summary>hubs — Cadastro dos bases logísticas, local onde os donativos são recebidos e processados antes de serem entregues no destino final (municipio)</summary>

### Tabela `hubs`

Cadastro dos bases logísticas, local onde os donativos são recebidos e processados antes de serem entregues no destino final (municipio)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| hub_id 🔑 | `integer` | Não | Identificador da base logística |
| name | `text` | Sim | Nome da base logística |
| main_contact_name | `text` | Sim | Nome do contato principal na base |
| main_contact_phone | `text` | Sim | Telefone do contato principal na base |
| main_contact_email | `text` | Sim | E-mail do contato principal na base |
| alt_contact_name | `text` | Sim | Nome do contato alternativo na base |
| alt_contact_phone | `text` | Sim | Telefone do contato alternativo na base |
| alt_contact_email | `text` | Sim | E-mail do contato alternativo na base |
| cep | `character varying(8)` | Sim | Código Postal do endereço da base |
| city_id | `integer` | Sim | Identificador da Cidade |
| district | `text` | Sim | Bairro da base |
| address | `text` | Sim | Rua e número do endereço da base |
| coordinates | `point` | Sim | Coordenadas (latitude e longitude) da base |
| enabled | `boolean` | Não | Se true, indica que a base está habilitada para receber doações. Bases desabilitadas não são listadass como destinos possíveis das doações. |
| hub | `boolean` | Não | Se true, indica que a base logística é um Hub. Hubs são responsáveis por abastecer os centros de distribuição. |
| dc | `boolean` | Não | Se true, indica que a base logística é um CD (Centro de Distribuição). Os CDs distribuem os donativos aos munípios. |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro no banco de dados |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_hubs_id | hub_id |  |
| `FOREIGN KEY` | pk_hubs_cityid | city_id | cities (city_id) |
</details>
<details>
<summary>hubs_cities — Cidades atendidas pela base logística.</summary>

### Tabela `hubs_cities`

Cidades atendidas pela base logística.

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| hub_id 🔑 | `integer` | Não | Identificador da base logística. |
| city_id 🔑 | `integer` | Não | Identificador da cidade atendida. |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro no banco de dados. |
| created_by | `text` | Sim | Nome de usuário de quem inseriu o registro. |
| updated_at | `timestamp with time zone` | Sim | Data e hora de atualização do registro no banco de dados. |
| updated_by | `text` | Sim | Nome de usuário de quem fez a última atualização no registro. |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_hubscities_hubid_cityid | hub_id, city_id |  |
| `FOREIGN KEY` | fk_hubscities_cityid | city_id | cities (city_id) |
| `FOREIGN KEY` | fk_hubscities_hubid | hub_id | hubs (hub_id) |
</details>
<details>
<summary>hubs_products — Essa tabela contém o produtos que podem ser armazenados ou processados na base logística</summary>

### Tabela `hubs_products`

Essa tabela contém o produtos que podem ser armazenados ou processados na base logística

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| hub_product_id 🔑 | `integer` | Não | Identificador do registro |
| hub_id | `integer` | Não | Identificador da base logística |
| product_id | `integer` | Não | Identificador do produto |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_hubsproducts_id | hub_product_id |  |
| `UNIQUE` | uk_hubsproducts_hubid_productid | hub_id, product_id |  |
| `FOREIGN KEY` | fk_hubsproducts_hubid | hub_id | hubs (hub_id) |
| `FOREIGN KEY` | fk_hubsproducts_productid | product_id | products (product_id) |
</details>
<details>
<summary>regions — Cadastro das coordenadorias regionais de proteção e defesa civil (regionais).</summary>

### Tabela `regions`

Cadastro das coordenadorias regionais de proteção e defesa civil (regionais).

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| region_id 🔑 | `integer` | Não | Identificador da regional |
| name | `text` | Sim | Nome da regional |
| city_id | `integer` | Sim | Identificador da cidade da regional |
| main_contact_name | `text` | Sim | Nome do contato principal na regional |
| main_contact_phone | `text` | Sim | Telefone do contato principal na regional |
| main_contact_email | `text` | Sim | E-mail do contato principal na regional |
| alt_contact_name | `text` | Sim | Nome do contato alternativo na regional |
| alt_contact_phone | `text` | Sim | Telefone do contato alternativo na regional |
| alt_contact_email | `text` | Sim | E-mail do contato alternativo na regional |
| cep | `character varying(8)` | Sim | Código posta da regional |
| district | `text` | Sim | Bairro da regional |
| address | `text` | Sim | Endereço da regional |
| coordinates | `point` | Sim | Coordenadas (latitude, longitude) da regional |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro no banco de dados |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_regions_id | region_id |  |
| `FOREIGN KEY` | pk_regions_cityid | city_id | cities (city_id) |
</details>
<details>
<summary>regions_cities — Relação de munícipios atendidos por cada coordenadorias regionais de proteção e defesa civil (regionais)</summary>

### Tabela `regions_cities`

Relação de munícipios atendidos por cada coordenadorias regionais de proteção e defesa civil (regionais)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| region_id 🔑 | `integer` | Não | Identificador da regional |
| city_id 🔑 | `integer` | Não | Identificador da cidade |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro no banco de dados |
| created_by | `text` | Sim | Nome de usuário de quem inseriou o registro |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última modificação no registro |
| updated_by | `text` | Sim | Nome de usuário de quem fez a última atualização no registro |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_hubscities_regionid_cityid | region_id, city_id |  |
| `FOREIGN KEY` | fk_hubscities_cityid | city_id | cities (city_id) |
| `FOREIGN KEY` | fk_hubscities_regionid | region_id | regions (region_id) |
</details>
<details>
<summary>carriers — Cadastro de transportadoras</summary>

### Tabela `carriers`

Cadastro de transportadoras

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| carrier_id 🔑 | `integer` | Não | Identificador da transportadora |
| name | `text` | Sim | Nome da transportadora |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi criado |
| created_by | `text` | Sim | Nome de usuário de quem criou o registro |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última vez que o registro foi modificado |
| updated_by | `text` | Sim | Nome de usuário de quem modificou o registro pela última vez |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_carriers_carrierid | carrier_id |  |
</details>
<details>
<summary>truck_types — Tipos de veículos (inicialmente eram apenas caminhões)</summary>

### Tabela `truck_types`

Tipos de veículos (inicialmente eram apenas caminhões)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| truck_type_id 🔑 | `integer` | Não | Identificador do tipo de veículo |
| name | `text` | Não | Nome do tipo de veículo |
| capacity_kg | `numeric(10,2)` | Sim | Capacidade do veículo em KG |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro no banco de dados |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última modificação no registro |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_trucktype_id | truck_type_id |  |
</details>
<details>
<summary>units — Cadastro de unidades de medidas</summary>

### Tabela `units`

Cadastro de unidades de medidas

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| unit_id 🔑 | `integer` | Não | Identificador da unidade de medida |
| name | `text` | Não | Nome da unidade de medida. Exemplo: Quilo, Caixa, Unidade |
| symbol | `text` | Sim | Simbolo/Sigla da unidade de medida. Exemplo: KG, CX, UN |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_units_id | unit_id |  |
| `UNIQUE` | uk_units_symbol | symbol |  |
</details>
<details>
<summary>unit_conversion_sets — Conjuntos de conversão de unidades</summary>

### Tabela `unit_conversion_sets`

Conjuntos de conversão de unidades

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| unit_conversion_set_id 🔑 | `uuid` | Não | Identificador do conjunto de conversões de unidade |
| name | `character varying(63)` | Não | Nome do conjunto |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro |
| updated_at | `timestamp with time zone` | Não | Data e hora em que o registro foi atualizado pela última vez |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_unitconversionsets_id | unit_conversion_set_id |  |
</details>
<details>
<summary>unit_conversions — Conversões de unidades do conjunto</summary>

### Tabela `unit_conversions`

Conversões de unidades do conjunto

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| unit_conversion_id 🔑 | `uuid` | Não | Identificador da conversão de unidade |
| unit_conversion_set_id | `uuid` | Não | Identificador do conjunto de conversões de unidades |
| in_unit_id | `integer` | Não | Identificador da unidade de medida de entrada |
| out_unit_id | `integer` | Não | Identificador da unidade de medida de saída |
| converter | `numeric(10,5)` | Não | Fator de conversão |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi criado |
| updated_at | `timestamp with time zone` | Não | Data e hora em que o registro foi atualizado pela última vez |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_unitconversions_id | unit_conversion_id |  |
| `UNIQUE` | uk_unitconversions_unitconvsetid_unitin_unitout | unit_conversion_set_id, in_unit_id, out_unit_id |  |
| `FOREIGN KEY` | fk_unitconversions_unitconvsetid | unit_conversion_set_id | unit_conversion_sets (unit_conversion_set_id) |
| `FOREIGN KEY` | fk_unitconversions_unitin | in_unit_id | units (unit_id) |
| `FOREIGN KEY` | fk_unitconversions_unitout | out_unit_id | units (unit_id) |
</details>
<details>
<summary>faq_categories — Categorias de FAQ (perguntas frequentes)</summary>

### Tabela `faq_categories`

Categorias de FAQ (perguntas frequentes)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| faq_category_id 🔑 | `integer` | Não | Identificador da categoria |
| name | `text` | Sim | Nome da categoria |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi criado |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_faq_categories_id | faq_category_id |  |
</details>
<details>
<summary>faq — FAQ (perguntas frequentes). Este recurso é usado pelos operadores do Callcenter para tirar dúvidas durante as ligações</summary>

### Tabela `faq`

FAQ (perguntas frequentes). Este recurso é usado pelos operadores do Callcenter para tirar dúvidas durante as ligações

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| faq_id 🔑 | `integer` | Não | Identificador da pergunta |
| question_text | `text` | Sim | Texto da pergunta |
| answer_text | `text` | Sim | Texto da resposta (aceita HTML) |
| faq_category_id | `integer` | Não | Identificador da categoria de FAQ |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi criado |
| created_by | `text` | Sim | Nome de usuário de quem inseriu o registro |
| updated_at | `timestamp with time zone` | Sim | Data e hora em que o registro foi alterado pela última vez |
| updated_by | `text` | Sim | Nome de usuário de quem atualizou o registro pela última vez |
| reported_at | `timestamp with time zone` | Sim | Data e hora da última vez que um usuário reportou um erro no FAQ |
| reported_by | `text` | Sim | Nome de usuário de quem reportou um erro no FAQ pela última vez |
| reported_text | `text` | Sim | Texto fornecido pelo usuário que reportou um erro no FAQ pela última vez |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_faq_id | faq_id |  |
</details>
<details>
<summary>categories — Categorias de produtos</summary>

### Tabela `categories`

Categorias de produtos

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| category_id 🔑 | `integer` | Não | Identificador da categoria |
| name | `text` | Sim | Nome da categoria |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_categories_id | category_id |  |
</details>
<details>
<summary>products — Cadastro de produtos (donativos)</summary>

### Tabela `products`

Cadastro de produtos (donativos)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| product_id 🔑 | `integer` | Não | Identificador do produto |
| name | `text` | Não | Nome do produto |
| offer_unit_id | `integer` | Sim | Identificador da unidade de medida usada nas ofertas (doações). |
| request_unit_id | `integer` | Sim | Identificador da unidade de medida usada nas demandas (necessidades dos munícipios). |
| priority | `integer` | Sim | Número que indica o nível de pririodade de um produto como donativo. Quanto maior o número, maior a demanda. |
| category_id | `integer` | Sim | Identificador da categoria do produto |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro no banco de dados |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última atulaização do registro no banco de dados |
| weight_kg | `numeric(10,2)` | Sim | Peso aproximado do produto em KG |
| allow_offer | `boolean` | Não | Se true, indique o produto está habilitado para ser recebido através de doações. Produtos desabilitados não são listados na tela de registro de doações do SAC. |
| icon_file_id | `uuid` | Sim | Identificador do arquivo PNG com o ícone do produto. |
| short_description | `character varying(15)` | Sim | [Obsoleto: Esta coluna deixou de ser usada e foi subsituida por "offer_short_description" e "request_short_description"] Descrição curta do produto para ofertas. Este campo é usado para adicionar observações ao nome do produto. O texto é exibido entre parenteses ao lado do nome do produto. |
| offer_short_description | `character varying(30)` | Sim | Descrição curta do produto para demandas. Este campo é usado para adicionar observações ao nome do produto. O texto é exibido entre parenteses ao lado do nome do produto. |
| request_short_description | `character varying(30)` | Sim | Descrição curta do produto para ofertas (doações). Este campo é usado para adicionar observações ao nome do produto. O texto é exibido entre parenteses ao lado do nome do produto. |
| unit_conversion_set_id | `uuid` | Sim | Id do conjunto de unidades de conversão associado |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_products_id | product_id |  |
| `FOREIGN KEY` | fk_products_categoryid | category_id | categories (category_id) |
| `FOREIGN KEY` | fk_products_iconfileid | icon_file_id | files (file_id) |
| `FOREIGN KEY` | fk_products_offerunitid | offer_unit_id | units (unit_id) |
| `FOREIGN KEY` | fk_products_requestunitid | request_unit_id | units (unit_id) |
| `FOREIGN KEY` | fk_products_unitconvsetid | unit_conversion_set_id | unit_conversion_sets (unit_conversion_set_id) |
</details>
<details>
<summary>events — Eventos</summary>

### Tabela `events`

Eventos

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| event_id 🔑 | `integer` | Não | Identificador do evento |
| name | `text` | Sim | Nome do evento |
| code | `character varying(2)` | Sim | Código fornecido para o evento |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi criado |
| updated_at | `timestamp with time zone` | Sim | Data e hora em que o registro foi atualizado pela última vez |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_events_id | event_id |  |
| `UNIQUE` | uk_events_code | code |  |
</details>
<details>
<summary>offers — Registro de ofertas (doações)</summary>

### Tabela `offers`

Registro de ofertas (doações)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| offer_id 🔑 | `uuid` | Não | Identificador da oferta |
| offer_number | `integer` | Sim | Número da oferta. É um identificador alternativo para a doação, de fácil leitura humana. O número é gerado através da SEQUENCE "offers_number_seq". |
| entity_id | `uuid` | Sim | Identificador da entidade que está registrando a oferta |
| protocol | `character varying(20)` | Não | Número do protocolo da oferta. O protocolo é um identificar único gerado após o registro da oferta, e compartilhado com o doador. |
| created_at | `timestamp with time zone` | Sim | Data e Hora de criação do registro. Precisa ser "NULLABLE" por uma estratégia usada na tela de atendimento da doação. |
| created_on | `interval` | Sim | Tempo gasto pelo operador para registrar a doação |
| doc_type | `character varying(5)` | Não | Tipo de documento ("CNPJ" ou "CPF") |
| organization_id | `integer` | Sim | Identificação da organização que está realizando a doação (somente no caso de empresas/CNPJ). |
| person_id | `integer` | Sim | Identificador da pessoa que está realizando a doação (somente no caso de pessoas/CPF) |
| giver_name | `text` | Sim | Nome do doador |
| availability_date | `date` | Sim | Data em que os donativos estão disponíveis |
| pickup_date | `date` | Sim | Data de previsão em que os donativos serão coletados |
| delivery_date | `date` | Sim | Data de previsão em que os donativos serão entregues |
| state_id | `integer` | Sim | Identificador do estado de origem da doação. |
| city_id | `integer` | Sim | Identificador da cidade de origem da doação |
| city_name | `text` | Sim | Nome da cidade de origem da doação (em alguns casos, "CITY_ID" pode ser NULL, e o nome da cidade é preenchido pelo operador. |
| cep | `character varying(8)` | Sim | Código postal de origem da doação |
| district | `text` | Sim | Bairro de origem da doação |
| address | `text` | Sim | Nome da rua/avenidade de origem da doação |
| address_number | `integer` | Sim | Número do endereço de origem da doação |
| address_complement | `text` | Sim | Complemento de endereço da origem da doação |
| coordinates | `point` | Sim | Coordenadas (latitude, longitude) da origem da doação |
| operator_username | `text` | Sim | Nome de usuário do operador que registrou a doação |
| operator_notes | `text` | Sim | Observações do operador que registrou a doação |
| contact_name | `text` | Sim | Nome de contato do doador |
| contact_phone | `text` | Sim | Telefone de contato do doador |
| contact_email | `text` | Sim | E-mail de contato do doador |
| transport_type | `integer` | Sim | [Obsoleto: Nunca foi usado] Tipo de transporte |
| shipping_available | `boolean` | Sim | Se true, siginifica que o doador possui transporte proprio disponível |
| shipping_modal | `smallint` | Sim | Modal de Transporte: 1-Terrestre, 2-Areo, 3-Maritimo |
| shipping_truck_type | `smallint` | Sim | [Obsoleto: Foi substituído por "shipping_truck_type_id"] Tipo de Caminhão: 1-Caminhão Toco 2-Caminhão Truck 3-Carreta 4-Rodotrem |
| shipping_truck_type_id | `integer` | Sim | Identificador do tipo de veículo |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última vez em que o registro foi atualizado |
| updated_by | `text` | Sim | Nome de usuário de quem atualizou o registro pela última vez |
| canceled_at | `timestamp with time zone` | Sim | Data e hora em que a oferta foi cancelada pelo doador |
| canceled_by | `text` | Sim | Nome de usuário de quem registrou o cancelamento da oferta |
| status | `character(1)` | Não | Situação: T-Temporário, C-Created, X-Canceleado |
| target_hub_id | `integer` | Sim | Identificador da base logística (Hub) para onde os donativos serão enviados |
| current_event_id | `integer` | Sim | Identificador do último evento ocorrido na oferta |
| estimated_weight_kg | `numeric(10,2)` | Sim | Total estimado em KG, quando o doador não souber informar os pesos dos donativos |
| callcenter | `boolean` | Não | Se true, significa que a oferta foi regitrada por um operador de callcenter |
| vehicle_plate | `character varying(20)` | Sim | Placa do veículo que vai transportar os donativos |
| driver_phone | `text` | Sim | Número de telefone do motortista que vai transportar os donativos |
| driver_name | `text` | Sim | Nome do motorista que vai transportar os donativos |
| expected_truck_inbound_date | `timestamp without time zone` | Sim | Data estimada de chegada do veículo na base logística |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_offers_id | offer_id |  |
| `UNIQUE` | uk_offers_protocol | protocol |  |
| `FOREIGN KEY` | fk_offers_cities | city_id | cities (city_id) |
| `FOREIGN KEY` | fk_offers_entityid | entity_id | entities (entity_id) |
| `FOREIGN KEY` | fk_offers_organizationid | organization_id | organizations (organization_id) |
| `FOREIGN KEY` | fk_offers_personid | person_id | persons (person_id) |
| `FOREIGN KEY` | fk_offers_stateid | state_id | states (state_id) |
| `FOREIGN KEY` | fk_offers_targethubid | target_hub_id | hubs (hub_id) |
| `FOREIGN KEY` | fk_offers_trucktypeid | shipping_truck_type_id | truck_types (truck_type_id) |
</details>
<details>
<summary>offers_products — Produtos registrados na oferta (doação)</summary>

### Tabela `offers_products`

Produtos registrados na oferta (doação)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| offer_product_id 🔑 | `uuid` | Não | Identificador do produto registrado na oferta (doação) |
| offer_id | `uuid` | Não | Identificador da oferta (doação) |
| product_id | `integer` | Sim | Identificador do produto |
| product_others | `text` | Sim | Outros (descritivo). Texto usado para descrever produtos que não estão cadastrados |
| unit_id | `integer` | Sim | Identificador da unidade de medida |
| quantity | `numeric(10,2)` | Sim | Quantidade do donativo. Se estiver NULL, é porque o doador não sabe a quantidade correta |
| notes | `text` | Sim | Observações sobre o donativo |
| estimated_weight_kg | `numeric(10,2)` | Sim | Peso estimado total do donativo |
| created_at | `timestamp with time zone` | Não | Data e hora de registro do produto na oferta |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_offersproducts_id | offer_product_id |  |
| `FOREIGN KEY` | fk_offersproducts_offerid | offer_id | offers (offer_id) |
| `FOREIGN KEY` | fk_offersproducts_productid | product_id | products (product_id) |
| `FOREIGN KEY` | fk_offersproducts_unitid | unit_id | units (unit_id) |
</details>
<details>
<summary>offers_history — Informações inseridas pelo operador e registradas em formato de histórico na oferta (doação).</summary>

### Tabela `offers_history`

Informações inseridas pelo operador e registradas em formato de histórico na oferta (doação).

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| offer_history_id 🔑 | `integer` | Não | Identificador da entrada no histórico da oferta |
| offer_id | `uuid` | Não |  |
| operator_username | `text` | Sim | Nome de usuário do operador que inseriu a informação no histórico |
| operator_notes | `text` | Sim | Texto inserido pelo operador no histórico |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi criado |
| type | `character(1)` | Não | Tipo de modificação: U-Update, X-Cancel |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_offerhistory_id | offer_history_id |  |
| `FOREIGN KEY` | fk_offerhistory_offerid | offer_id | offers (offer_id) |
</details>
<details>
<summary>requests — Registro de solicitações de materiais (demandas)</summary>

### Tabela `requests`

Registro de solicitações de materiais (demandas)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| request_id 🔑 | `uuid` | Não | Identificador da demanda |
| request_number | `integer` | Sim | Número sequência da demanda. Este é um Identificador alternativo de fácil leitura para uso interno. |
| protocol | `character varying(20)` | Não | Número de protocolo do registro de demanda. |
| subject | `text` | Sim | Assunto/título da demanda. |
| entity_id | `uuid` | Sim | Identificador da entidade |
| requester_name | `text` | Sim | Nome de quem solicitou |
| request_date | `date` | Não | Data da solicitação |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro |
| created_by | `text` | Sim | Nome de usuário de quem critou o registro |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última modificação do registro |
| updated_by | `text` | Sim | Nome de usuário de quem fez a última modificação no registro |
| canceled_at | `timestamp with time zone` | Sim | Data e hora em que a demanda foi cancelada |
| canceled_by | `text` | Sim | Nome de usuário de quem registrou o cancelamento da demanda |
| canceled_reason | `text` | Sim | Motivo do cancelamento da demanda |
| delivery_address_id | `uuid` | Sim | Identificador do endereço de entrega |
| delivery_method | `character(1)` | Não | Método de entrega: D-Delivery, P-Pickup |
| responsible_name | `text` | Sim | Nome do responsável por retirar ou receber a mercadoria |
| responsible_phone | `text` | Sim | Telefone do responsável por retirar ou receber a mercadoria |
| pickup_date | `timestamp with time zone` | Sim | Data de retirada da mercadoria |
| closed_at | `timestamp with time zone` | Sim | Data e hora em que a demanda foi fechada (arquivada). |
| closed_by | `text` | Sim | Nome de usuário de quem fechou (arquivou) a demanda |
| status | `character(1)` | Não | Situação:  T-Temporário C-Created A-Approving E-Ended X-Canceled D-Delivered |
| current_event_id | `integer` | Sim | Identificador do evento atual associado a demanda |
| approval_status | `character(1)` | Sim | Situação da aprovação: O-Open T-Totally Approved P-Partially Approved R-Reproved |
| notes | `text` | Sim | Observações da demanda |
| supply_progress | `numeric(4,1)` | Não | Valor de 0 a 100 que indica o percentual de progresso do atendimento da demanda. O percentual é calculado automaticamente na operação de atendimento das demandas.  |
| approval_level | `integer` | Sim | Nível hierarquico da entidade que realizou a aprovação (total ou parcial). Quandou houver múltiplas aprovações, mantém sempre o nível mais elevado (menor número) |
| approval_at | `timestamp with time zone` | Sim | Data e hora em que a demanda foi aprovada (total ou parcial) |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_requests_id | request_id |  |
| `CHECK` | ck_requests_supplyprogress | supply_progress | `CHECK ((supply_progress >= (0)::numeric))` |
| `FOREIGN KEY` | fk_requests_deliveryaddrid | delivery_address_id | addresses (address_id) |
| `FOREIGN KEY` | fk_requests_entityid | entity_id | entities (entity_id) |
</details>
<details>
<summary>requests_products — Produtos que compões a demanda</summary>

### Tabela `requests_products`

Produtos que compões a demanda

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| request_product_id 🔑 | `uuid` | Não | Identificador do registro de solicitação de produto na demanda |
| request_id | `uuid` | Não |  |
| product_id | `integer` | Não | Identificador do produto |
| unit_id | `integer` | Não | Identificador da unidade de medida usada para quantificar o produto |
| quantity | `numeric(10,2)` | Sim | Quantidade solicitada |
| quantity_edited | `numeric(10,2)` | Sim | Quantidade modificada após a solicitação |
| quantity_approved | `numeric(10,2)` | Sim | Quantidade aprovada |
| quantity_supplied | `numeric(10,2)` | Sim | Quantidade atendida |
| notes | `text` | Sim | Observações associadas ao produto |
| created_at | `timestamp with time zone` | Não | Data e hora em que o registro foi inserido |
| updated_by | `text` | Sim | Nome de usuário de quem fez a última atualização no registro |
| updated_at | `timestamp with time zone` | Sim | Data e hora da última atualização do registro |
| approved_by | `text` | Sim | Nome de usuário de quem fez a aprovação |
| approved_at | `timestamp with time zone` | Sim | Data e hora da aprovação |
| supplied_at | `timestamp with time zone` | Sim | Data e hora do atendimento da demanda |
| supplied_by | `text` | Sim | Nome de usuário de quem registrou o atendimento da demanda |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_requestproducts_id | request_product_id |  |
| `FOREIGN KEY` | fk_requestproducts_productid | product_id | products (product_id) |
| `FOREIGN KEY` | fk_requestproducts_requestid | request_id | requests (request_id) |
| `FOREIGN KEY` | pk_requestproducts_unitid | unit_id | units (unit_id) |
</details>
<details>
<summary>requests_approvals — Registro de aprovações da demanda (histórico)</summary>

### Tabela `requests_approvals`

Registro de aprovações da demanda (histórico)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| request_approval_id 🔑 | `uuid` | Não | Identificador da aprovação |
| request_id | `uuid` | Não | Identificador da demanda |
| request_product_id | `uuid` | Não | Identificador do produto |
| quantity_approved | `numeric(10,2)` | Sim | Quantidade aprovada |
| approval_entity_id | `uuid` | Não | Identificador da entidade responsável pela aprovação |
| approval_at | `timestamp with time zone` | Sim | Data e hora da aprovação |
| approval_by | `text` | Sim | Nome de usuário de quem aprovou |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_requestappr_approval_id | request_approval_id |  |
| `UNIQUE` | uk_requestappr_requestproductid_approvalentityid | request_product_id, approval_entity_id |  |
| `FOREIGN KEY` | fk_requestappr_approvalentityid | approval_entity_id | entities (entity_id) |
| `FOREIGN KEY` | fk_requestappr_requestid | request_id | requests (request_id) |
| `FOREIGN KEY` | fk_requestappr_requestproductid | request_product_id | requests_products (request_product_id) |
</details>
<details>
<summary>vehicle_entries_exits — Registro de entradas e saídas de veículos (controle de portaria)</summary>

### Tabela `vehicle_entries_exits`

Registro de entradas e saídas de veículos (controle de portaria)

#### Colunas

| Coluna | Tipo | Nulo | Comentário |
|--------|------|------|------------|
| vehicle_entry_exit_id 🔑 | `integer` | Não | Identificador da entrada ou saída de veículo |
| entity_id | `uuid` | Não | Identificador da entidade para qual a entrada ou saída de veículo foi registrada |
| queue_number | `integer` | Não | Número do veículo na fila para entrada |
| driver_name | `text` | Sim | Nome do motorista |
| driver_phone | `text` | Sim | Número de telefone do motorista |
| carrier_id | `integer` | Sim | Identificador da transportadora |
| carrier_others | `text` | Sim | Nome da transportadora caso não esteja cadastrada |
| vehicle_plate | `character varying(30)` | Sim | Placa do veículo |
| vehicle_type_id | `integer` | Sim | Identificador do tipo de veículo |
| palletized | `character(1)` | Não | Paletizado: Y-Sim, N-Não, P-Parcial |
| load | `boolean` | Não | Se true, significa que o veículo vai fazer um carregamento |
| unload | `boolean` | Não | Se true, significa que o veículo vai descarregar |
| cargo_description | `text` | Sim | Descrição da carga transportada |
| estimated_weight_kg | `numeric(10,2)` | Sim | Peso estimado da carga em KG |
| state_id | `integer` | Sim | Identificador do estado (UF) |
| city_id | `integer` | Sim | Identificador da cidade |
| city_name | `text` | Sim | Nome da cidade, usado quando a cidade não estiver cadastrada |
| has_invoice | `boolean` | Não | Se true, indica que o motorista possui nota fiscal da mercadoria. Essa informação é útil para o planejamento da descarga pois é mais fácil registrar a partir de nota fiscal. |
| offer_id | `uuid` | Sim | Identificador da oferta (doação). Se o motorista veio descarregar e tem o protocolo da doação, é possível associar a entrega com o registro da oferta. |
| request_id | `uuid` | Sim | Identificador da demanda. Se o motorista veio coletar e tem o protocolo da demanda, é possível associar a coleta com o registro da demanda. |
| created_at | `timestamp with time zone` | Não | Data e hora de criação do registro |
| created_by | `text` | Sim | Data e hora da última modificação do registro |
| authorized_at | `timestamp with time zone` | Sim | Data e hora em que a carga ou descargar foi autorizada |
| authorized_by | `text` | Sim | Nome de usuário de quem autorizou a carga ou descarga |
| inbound_at | `timestamp with time zone` | Sim | Data e hora em que ocorreu o carregamento |
| inbound_by | `text` | Sim | Nome de usuário de quem registrou o carregamento |
| started_at | `timestamp with time zone` | Sim | Data e hora em que foi iniciado o carregamento ou descarregamento |
| started_by | `text` | Sim | Nome de usuário de quem registrou o início do carregamento ou descarregamento |
| outbound_at | `timestamp with time zone` | Sim | Data e hora em que ocorreu o descarregamento |
| outbound_by | `text` | Sim | Nome de usuário de quem registrou o descarregamento |
| canceled_at | `timestamp with time zone` | Sim | Data e hora em que a operação foi cancelada |
| canceled_by | `text` | Sim | Nome de usuário de quem registrou o cancelamento |
| canceled_reason | `text` | Sim | Motivo do cancelamento |
| status | `character(1)` | Não | Status: T-Temporary, C-Created, A-Authorized, I-Inbound, S-Started, O-Outbound, X-Canceled |

#### Constraints

| Tipo | Nome | Coluna(s) | Referencias / Regras |
|------|------|-----------|----------------------|
| `PRIMARY KEY` | pk_vehicleentriesexits_id | vehicle_entry_exit_id |  |
| `FOREIGN KEY` | fk_vehicleentriesexits_carrierid | carrier_id | carriers (carrier_id) |
| `FOREIGN KEY` | fk_vehicleentriesexits_cityid | city_id | cities (city_id) |
| `FOREIGN KEY` | fk_vehicleentriesexits_entityid | entity_id | entities (entity_id) |
| `FOREIGN KEY` | fk_vehicleentriesexits_offerid | offer_id | offers (offer_id) |
| `FOREIGN KEY` | fk_vehicleentriesexits_requestid | request_id | requests (request_id) |
| `FOREIGN KEY` | fk_vehicleentriesexits_stateid | state_id | states (state_id) |
| `FOREIGN KEY` | fk_vehicleentriesexits_typeid | vehicle_type_id | truck_types (truck_type_id) |
</details>