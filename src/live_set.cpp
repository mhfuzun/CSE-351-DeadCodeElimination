#include <algorithm>
#include <string>
#include <vector>

#include "live_set.hpp"

/* ===============================
 * Constructor / Destructor
 * =============================== */

Live_Set::Live_Set()
    : liveSet{}
{
}

Live_Set::~Live_Set() = default;

/* ===============================
 * Query operations
 * =============================== */

/**
 * Checks whether a variable is present in the live set.
 */
bool Live_Set::is_exist(const std::string& varName) const
{
    return std::find(liveSet.begin(), liveSet.end(), varName) != liveSet.end();
}

/* ===============================
 * Modification operations
 * =============================== */

/**
 * Inserts a new variable into the live set if it does not already exist.
 *
 * @return true  if the variable was inserted
 * @return false if the variable already exists
 */
bool Live_Set::push_new_var(const std::string& varName)
{
    if (is_exist(varName))
        return false;

    liveSet.push_back(varName);
    return true;
}

/**
 * Removes a variable from the live set.
 *
 * @return true  if at least one entry was removed
 * @return false if the variable was not present
 */
bool Live_Set::remove_var(const std::string& varName)
{
    const std::size_t oldSize = liveSet.size();

    liveSet.erase(
        std::remove(liveSet.begin(), liveSet.end(), varName),
        liveSet.end()
    );

    return liveSet.size() != oldSize;
}

/* ===============================
 * Accessors
 * =============================== */

/**
 * Returns a read-only reference to the underlying live set.
 */
const std::vector<std::string>& Live_Set::getSet() const
{
    return liveSet;
}
