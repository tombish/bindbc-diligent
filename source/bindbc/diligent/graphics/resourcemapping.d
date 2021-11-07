/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.engine.resourcemapping;

/// \file
/// Definition of the Diligent::IResourceMapping interface and related data structures

import bindbc.diligent.graphics.deviceobject;

// {6C1AC7A6-B429-4139-9433-9E54E93E384A}
static const INTERFACE_ID IID_ResourceMapping =
    INTERFACE_ID(0x6c1ac7a6, 0xb429, 0x4139, [0x94, 0x33, 0x9e, 0x54, 0xe9, 0x3e, 0x38, 0x4a]);

/// Describes the resourse mapping object entry
struct ResourceMappingEntry
{ 
    /// Object name
    const(char)* Name = null;

    /// Pointer to the object's interface
    IDeviceObject* pObject = null;

    uint ArrayIndex = 0;
}


/// Resource mapping description
struct ResourceMappingDesc
{
    /// Pointer to the array of resource mapping entries.
    /// The last element in the array must be default value
    /// created by ResourceMappingEntry::ResourceMappingEntry()
    ResourceMappingEntry* pEntries = null;
}

/// Resource mapping

/// This interface provides mapping between literal names and resource pointers.
/// It is created by IRenderDevice::CreateResourceMapping().
/// \remarks Resource mapping holds strong references to all objects it keeps.
struct IResourceMappingMethods
{
    /// Adds a resource to the mapping.

    /// \param [in] Name - Resource name.
    /// \param [in] pObject - Pointer to the object.
    /// \param [in] bIsUnique - Flag indicating if a resource with the same name
    ///                         is allowed to be found in the mapping. In the latter
    ///                         case, the new resource replaces the existing one.
    ///
    /// \remarks Resource mapping increases the reference counter for referenced objects. So an
    ///          object will not be released as long as it is in the resource mapping.
    void* AddResource(IResourceMapping*,
                                     const(char)*   Name,
                                     IDeviceObject* pObject,
                                     bool           bIsUnique);

    /// Adds resource array to the mapping.

    /// \param [in] Name - Resource array name.
    /// \param [in] StartIndex - First index in the array, where the first element will be inserted
    /// \param [in] ppObjects - Pointer to the array of objects.
    /// \param [in] NumElements - Number of elements to add
    /// \param [in] bIsUnique - Flag indicating if a resource with the same name
    ///                         is allowed to be found in the mapping. In the latter
    ///                         case, the new resource replaces the existing one.
    ///
    /// \remarks Resource mapping increases the reference counter for referenced objects. So an
    ///          object will not be released as long as it is in the resource mapping.
    void* AddResourceArray(IResourceMapping*,
                                          const(char)*           Name,
                                          uint                   StartIndex,
                                          const(IDeviceObject)** ppObjects,
                                          uint                   NumElements,
                                          bool                   bIsUnique);

    /// Removes a resource from the mapping using its literal name.

    /// \param [in] Name - Name of the resource to remove.
    /// \param [in] ArrayIndex - For array resources, index in the array
    void* RemoveResourceByName(IResourceMapping*, const(char)* Name, uint ArrayIndex = 0);

    /// Finds a resource in the mapping.

    /// \param [in] Name        - Resource name.
    /// \param [in] ArrayIndex  - for arrays, index of the array element.
    ///
    /// \return Pointer to the object with the given name and array index.
    ///
    /// \remarks The method does *NOT* increase the reference counter
    ///          of the returned object, so Release() must not be called.
    ///          The pointer is guaranteed to be valid until the object is removed
    ///          from the resource mapping, or the mapping is destroyed.
    IDeviceObject** GetResource(IResourceMapping*, const(char)* Name, uint ArrayIndex = 0);

    /// Returns the size of the resource mapping, i.e. the number of objects.
    size_t* GetSize(IResourceMapping*);
}

struct IResourceMappingVtbl { IResourceMappingMethods ResourceMapping; }
struct IResourceMapping { IResourceMappingVtbl* pVtbl; }

void* IResourceMapping_AddResource(IResourceMapping* resMapping,
                                     const(char)*   name,
                                     IDeviceObject* pObject,
                                     bool           isUnique) {
    return resMapping.pVtbl.ResourceMapping.AddResource(resMapping, name, pObject, isUnique);
}

void* IResourceMapping_AddResourceArray(IResourceMapping* resMapping,
                                          const(char)*           name,
                                          uint                   startIndex,
                                          const(IDeviceObject)** ppObjects,
                                          uint                   numElements,
                                          bool                   bIsUnique) {
    return resMapping.pVtbl.ResourceMapping.AddResourceArray(resMapping, name, startIndex, ppObjects, numElements, bIsUnique);
}

void* IResourceMapping_RemoveResourceByName(IResourceMapping* resMapping, const(char)* name, uint arrayIndex = 0) {
    return resMapping.pVtbl.ResourceMapping.RemoveResourceByName(resMapping, name, arrayIndex);
}

IDeviceObject** IResourceMapping_GetResource(IResourceMapping* resMapping, const(char)* name, uint arrayIndex = 0) {
    return resMapping.pVtbl.ResourceMapping.GetResource(resMapping, name, arrayIndex);
}

size_t* IResourceMapping_GetSize(IResourceMapping* resMapping) {
    return resMapping.pVtbl.ResourceMapping.GetSize(resMapping);
}
