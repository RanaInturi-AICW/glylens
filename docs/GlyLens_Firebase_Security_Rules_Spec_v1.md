# Firebase Security Rules Specification v1.0

Principles:

1. Least privilege
2. Anonymous users restricted
3. User data isolated
4. No public write access

Requirements:

Anonymous:
- Read public food data
- Limited scan usage

Registered:
- Access own history only

Premium:
- Same security model
- Feature unlocks only

Collections:

users:
owner access only

food_scans:
owner access only

assistant_conversations:
owner access only

foods:
read only

ingredients:
read only

products:
read only

Audit all rules before production release.
