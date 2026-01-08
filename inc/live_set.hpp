#pragma once

#include <string>
#include <vector>

/**
 * Live variable set used during data-flow analysis.
 *
 * This class maintains a collection of variable names
 * that are considered live at a given program point.
 */
class Live_Set {
public:
    /* ===============================
     * Construction / Destruction
     * =============================== */

    Live_Set();
    ~Live_Set();

    /* ===============================
     * Query operations
     * =============================== */

    /**
     * Checks whether a variable exists in the live set.
     */
    bool is_exist(const std::string& varName) const;

    /* ===============================
     * Modification operations
     * =============================== */

    /**
     * Inserts a new variable into the live set if it does not already exist.
     *
     * @return true  if the variable was inserted
     * @return false if the variable already exists
     */
    bool push_new_var(const std::string& varName);

    /**
     * Removes a variable from the live set.
     *
     * @return true  if the variable was removed
     * @return false if the variable was not present
     */
    bool remove_var(const std::string& varName);

    /* ===============================
     * Accessors
     * =============================== */

    /**
     * Returns a read-only reference to the underlying live set.
     */
    const std::vector<std::string>& getSet() const;

private:
    std::vector<std::string> liveSet;
};
