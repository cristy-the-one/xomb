/*
 * ti_array_object.d
 *
 * This module implements the TypeInfo for Object[]
 *
 * License: Public Domain
 *
 */

module mindrt.typeinfo.ti_array_object;

class TypeInfo_AC : TypeInfo {
	hash_t getHash(void *p) {
		Object[] s = *cast(Object[]*)p;

		hash_t hash = 0;

		foreach (Object o; s) {
			if (o) {
				hash += o.toHash();
			}
		}
		return hash;
	}

	int equals(void *p1, void *p2) {
		Object[] s1 = *cast(Object[]*)p1;
		Object[] s2 = *cast(Object[]*)p2;

		if (s1.length == s2.length) {
			for (size_t u = 0; u < s1.length; u++) {
				Object o1 = s1[u];
				Object o2 = s2[u];

				// Do not pass null's to Object.opEquals()
				if (o1 is o2 ||	(!(o1 is null) && !(o2 is null) && o1.opEquals(o2))) {
					continue;
				}
				return 0;
			}
			return 1;
		}
		return 0;
	}

	int compare(void *p1, void *p2) {
		Object[] s1 = *cast(Object[]*)p1;
		Object[] s2 = *cast(Object[]*)p2;
		ptrdiff_t c;

		c = cast(ptrdiff_t)s1.length - cast(ptrdiff_t)s2.length;
		if (c == 0) {
			for (size_t u = 0; u < s1.length; u++) {
				Object o1 = s1[u];
				Object o2 = s2[u];

				if (o1 is o2) {
					continue;
				}

				// Regard null references as always being "less than"
				if (o1) {
					if (!o2) {
						c = 1;
						break;
					}
					c = o1.opCmp(o2);
					if (c) {
						break;
					}
				}
				else {
					c = -1;
					break;
				}
			}
		}
		if (c < 0) {
			c = -1;
		}
		else if (c > 0) {
			c = 1;
		}
		return c;
	}

	size_t tsize() {
		return (Object[]).sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next() {
		return typeid(Object);
	}
}
